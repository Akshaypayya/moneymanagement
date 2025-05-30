import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:flutter/foundation.dart';

class GoalListRepository {
  final NetworkService _networkService;
  final Ref ref;

  GoalListRepository(this._networkService, this.ref);

  Future<GoalListModel> getGoalsList() async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('GOAL LIST ERROR: Authentication token is missing');
        return GoalListModel(
          status: 'failed',
          data: [],
        );
      }

      debugPrint('GOAL LIST REQUEST: GET ${AppUrl.goalListUrl}');

      final response = await _networkService.get(
        AppUrl.goalListUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('GOAL LIST RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        debugPrint('GOAL LIST RESPONSE TYPE: ${response.runtimeType}');
        debugPrint('GOAL LIST RESPONSE KEYS: ${response.keys.toList()}');

        if (response['data'] != null && response['data'] is List) {
          final dataList = response['data'] as List;
          debugPrint('GOAL LIST DATA COUNT: ${dataList.length}');

          for (int i = 0; i < dataList.length; i++) {
            final goalItem = dataList[i];
            debugPrint('GOAL $i DEBUG:');
            debugPrint('  - goalName: ${goalItem['goalName']}');
            debugPrint('  - goalPic: ${goalItem['goalPic']}');
            debugPrint('  - goalPicExtension: ${goalItem['goalPicExtension']}');
            debugPrint(
                '  - goalPicContentType: ${goalItem['goalPicContentType']}');
            debugPrint('  - All keys: ${goalItem.keys.toList()}');
          }
        }

        final goalListModel = GoalListModel.fromJson(response);

        if (goalListModel.isSuccess) {
          debugPrint(
              'GOAL LIST: Successfully retrieved ${goalListModel.data.length} goals');

          for (var goal in goalListModel.data) {
            debugPrint('Goal: ${goal.goalName}');
            debugPrint(
                '  - Available Balance: ${goal.formattedAvailableBalance}');
            debugPrint('  - Goal Pic: ${goal.goalPic}');
            debugPrint('  - Goal Pic Extension: ${goal.goalPicExtension}');
            debugPrint('  - Icon Asset: ${goal.iconAsset}');
            debugPrint(
                '  - Has Goal Pic Data: ${goal.goalPic != null && goal.goalPic!.isNotEmpty}');
          }

          if (goalListModel.data.isEmpty) {
            debugPrint(
                'GOAL LIST: No goals found for this user, but request was successful');
          }
        } else {
          debugPrint('GOAL LIST: API returned non-success status');
          debugPrint('Status: ${goalListModel.status}');
        }

        return goalListModel;
      } else {
        debugPrint('GOAL LIST: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return GoalListModel(
          status: 'failed',
          data: [],
        );
      }
    } catch (e, stackTrace) {
      debugPrint('GOAL LIST ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return GoalListModel(
        status: 'failed',
        data: [],
      );
    }
  }
}
