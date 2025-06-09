import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/initiate_gold_sell_transaction_model.dart';

class InitiateSellGoldRepository {
  final NetworkService _networkService;
  final Ref ref;

  InitiateSellGoldRepository(this._networkService, this.ref);

  Future<InitiateSellGoldResponse> initiateSellGold({
    required String goalName,
  }) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('INITIATE SELL GOLD ERROR: Authentication token is missing');
        return InitiateSellGoldResponse(
          status: 'failed',
          message: 'Authentication token is missing',
        );
      }

      final request = InitiateSellGoldRequest(
        goalName: goalName,
        operation: 1,
      );

      debugPrint(
          'INITIATE SELL GOLD REQUEST: POST ${AppUrl.intitiateGoalSellTransactionUrl}');
      debugPrint('INITIATE SELL GOLD: Goal name: $goalName');
      debugPrint('INITIATE SELL GOLD: Operation: 1');
      debugPrint('INITIATE SELL GOLD: Request body: ${request.toJson()}');

      final response = await _networkService.post(
        AppUrl.intitiateGoalSellTransactionUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
          'Content-Type': 'application/json',
        },
        body: request.toJson(),
      );

      debugPrint('INITIATE SELL GOLD RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final initiateSellGoldResponse =
            InitiateSellGoldResponse.fromJson(response);

        if (initiateSellGoldResponse.isSuccess) {
          debugPrint(
              'INITIATE SELL GOLD: Successfully initiated sell gold for goal: $goalName');
          debugPrint(
              'INITIATE SELL GOLD: Message: ${initiateSellGoldResponse.message}');
          if (initiateSellGoldResponse.data != null) {
            final data = initiateSellGoldResponse.data!;
            debugPrint(
                'INITIATE SELL GOLD: Transaction ID: ${data.transactionId}');
            debugPrint(
                'INITIATE SELL GOLD: Transaction Amount: ${data.formattedTransactionAmount}');
            debugPrint(
                'INITIATE SELL GOLD: Charge Amount: ${data.formattedChargeAmount}');
          }
        } else {
          debugPrint('INITIATE SELL GOLD: Initiate sell gold failed');
          debugPrint(
              'INITIATE SELL GOLD: Status: ${initiateSellGoldResponse.status}');
          debugPrint(
              'INITIATE SELL GOLD: Message: ${initiateSellGoldResponse.message}');
        }

        return initiateSellGoldResponse;
      } else {
        debugPrint('INITIATE SELL GOLD: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return InitiateSellGoldResponse(
          status: 'failed',
          message: 'Invalid response format',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('INITIATE SELL GOLD ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return InitiateSellGoldResponse(
        status: 'failed',
        message: 'Initiate sell gold failed: ${e.toString()}',
      );
    }
  }
}
