import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/sell_gold_model.dart';

class SellGoldRepository {
  final NetworkService _networkService;
  final Ref ref;

  SellGoldRepository(this._networkService, this.ref);

  Future<SellGoldResponse> sellGold({
    required String goalName,
  }) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('SELL GOLD ERROR: Authentication token is missing');
        return SellGoldResponse(
          status: 'failed',
          message: 'Authentication token is missing',
        );
      }

      final request = SellGoldRequest(goalName: goalName);

      debugPrint('SELL GOLD REQUEST: POST ${AppUrl.goalSellGoldUrl}');
      debugPrint('SELL GOLD: Goal name: $goalName');
      debugPrint('SELL GOLD: Request body: ${request.toJson()}');

      final response = await _networkService.post(
        AppUrl.goalSellGoldUrl,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
          'Content-Type': 'application/json',
        },
        body: request.toJson(),
      );

      debugPrint('SELL GOLD RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final sellGoldResponse = SellGoldResponse.fromJson(response);

        if (sellGoldResponse.isSuccess) {
          debugPrint('SELL GOLD: Successfully sold gold for goal: $goalName');
          debugPrint('SELL GOLD: Message: ${sellGoldResponse.message}');
          if (sellGoldResponse.data != null) {
            final data = sellGoldResponse.data!;
            debugPrint('SELL GOLD: Gold sold: ${data.formattedGoldSold}');
            debugPrint('SELL GOLD: Sold price: ${data.formattedSoldPrice}');
            debugPrint('SELL GOLD: Currency: ${data.currencyCode}');
          }
        } else {
          debugPrint('SELL GOLD: Sell gold failed');
          debugPrint('SELL GOLD: Status: ${sellGoldResponse.status}');
          debugPrint('SELL GOLD: Message: ${sellGoldResponse.message}');
        }

        return sellGoldResponse;
      } else {
        debugPrint('SELL GOLD: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return SellGoldResponse(
          status: 'failed',
          message: 'Invalid response format',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('SELL GOLD ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return SellGoldResponse(
        status: 'failed',
        message: 'Sell gold failed: ${e.toString()}',
      );
    }
  }
}
