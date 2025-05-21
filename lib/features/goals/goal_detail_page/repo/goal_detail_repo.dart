import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/storage/shared_preference/shared_preference_service.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:flutter/foundation.dart';

class GoalDetailRepository {
  final NetworkService _networkService;
  final Ref ref;

  GoalDetailRepository(this._networkService, this.ref);

  Future<GoalViewModel> getGoalDetail(String goalName) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('GOAL DETAIL ERROR: Authentication token is missing');
        return GoalViewModel(
          status: 'failed',
          data: null,
        );
      }

      final endpoint = AppUrl.goalViewByNameUrl(goalName);
      debugPrint('GOAL DETAIL REQUEST: GET $endpoint');

      final response = await _networkService.get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
        },
      );

      debugPrint('GOAL DETAIL RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final goalViewModel = GoalViewModel.fromJson(response);

        if (goalViewModel.isSuccess) {
          debugPrint(
              'GOAL DETAIL: Successfully retrieved goal data for: $goalName');
          if (goalViewModel.data != null) {
            debugPrint('Goal Name: ${goalViewModel.data!.goalName}');
            debugPrint(
                'Target Amount: ${goalViewModel.data!.formattedTargetAmount}');
            debugPrint(
                'Available Balance: ${goalViewModel.data!.formattedAvailableBalance}');
          }
        } else {
          debugPrint('GOAL DETAIL: Failed to get goal data');
          debugPrint('Status: ${goalViewModel.status}');
        }

        return goalViewModel;
      } else {
        debugPrint('GOAL DETAIL: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return GoalViewModel(
          status: 'failed',
          data: null,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('GOAL DETAIL ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return GoalViewModel(
        status: 'failed',
        data: null,
      );
    }
  }
}
