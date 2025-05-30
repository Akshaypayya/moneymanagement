import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/transfer_amount_model.dart';

class TransferAmountRepository {
  final NetworkService _networkService;
  final Ref ref;

  TransferAmountRepository(this._networkService, this.ref);

  Future<TransferAmountResponse> transferAmount({
    required String goalName,
    required double amount,
  }) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('TRANSFER AMOUNT ERROR: Authentication token is missing');
        return TransferAmountResponse(
          status: 'failed',
          message: 'Authentication token is missing',
        );
      }

      final request = TransferAmountRequest(
        goalName: goalName,
        amount: amount,
      );

      debugPrint('TRANSFER AMOUNT REQUEST: POST ${AppUrl.transferAmountUrl}');
      debugPrint('TRANSFER AMOUNT: Goal name: $goalName');
      debugPrint('TRANSFER AMOUNT: Amount: $amount');
      debugPrint('TRANSFER AMOUNT: Request body: ${request.toJson()}');

      final response = await _networkService.post(
        AppUrl.transferAmountUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
          'Content-Type': 'application/json',
        },
        body: request.toJson(),
      );

      debugPrint('TRANSFER AMOUNT RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final transferResponse = TransferAmountResponse.fromJson(response);

        if (transferResponse.isSuccess) {
          debugPrint(
              'TRANSFER AMOUNT: Successfully transferred SAR $amount to goal: $goalName');
          debugPrint('TRANSFER AMOUNT: Message: ${transferResponse.message}');
        } else {
          debugPrint('TRANSFER AMOUNT: Transfer failed');
          debugPrint('TRANSFER AMOUNT: Status: ${transferResponse.status}');
          debugPrint('TRANSFER AMOUNT: Message: ${transferResponse.message}');
        }

        return transferResponse;
      } else {
        debugPrint('TRANSFER AMOUNT: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return TransferAmountResponse(
          status: 'failed',
          message: 'Invalid response format',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('TRANSFER AMOUNT ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return TransferAmountResponse(
        status: 'failed',
        message: 'Transfer failed: ${e.toString()}',
      );
    }
  }
}
