import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/features/notifcation_page/model/notification_model.dart';

class NotificationRepository {
  final NetworkService _networkService;
  final Ref ref;

  NotificationRepository(this._networkService, this.ref);

  Future<NotificationListModel> getNotificationList({
    int iDisplayStart = 0,
    int iDisplayLength = 20,
  }) async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('NOTIFICATION ERROR: Authentication token is missing');
        return NotificationListModel(
          status: 'failed',
          data: null,
        );
      }

      final endpoint =
          AppUrl.getNotificationListUrl(iDisplayStart, iDisplayLength);

      debugPrint('NOTIFICATION REQUEST: GET $endpoint');
      debugPrint('NOTIFICATION: Display start: $iDisplayStart');
      debugPrint('NOTIFICATION: Display length: $iDisplayLength');

      final response = await _networkService.get(
        endpoint,
        headers: {
          'Authorization': 'Bearer $token',
          'app': 'SA',
        },
      );

      debugPrint('NOTIFICATION RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final notificationModel = NotificationListModel.fromJson(response);

        if (notificationModel.isSuccess) {
          debugPrint(
              'NOTIFICATION: Successfully retrieved ${notificationModel.data?.aaData.length ?? 0} notifications');

          if (notificationModel.data != null) {
            final data = notificationModel.data!;
            debugPrint('Total records: ${data.iTotalRecords}');
            debugPrint('Total display records: ${data.iTotalDisplayRecords}');
            debugPrint('Unread count: ${data.unreadCount}');
            debugPrint('Page number: ${data.pageNumber}');

            for (var i = 0; i < data.aaData.length; i++) {
              final notification = data.aaData[i];
              debugPrint('Notification $i:');
              debugPrint('  - ID: ${notification.notificationId}');
              debugPrint('  - Type: ${notification.type}');
              debugPrint('  - Name: ${notification.name}');
              debugPrint('  - Message: ${notification.message}');
              debugPrint('  - Time: ${notification.notificationTime}');
              debugPrint('  - Status: ${notification.status}');
              debugPrint('  - Wallet: ${notification.wallet}');
            }
          }
        } else {
          debugPrint('NOTIFICATION: Failed to get notifications');
          debugPrint('Status: ${notificationModel.status}');
        }

        return notificationModel;
      } else {
        debugPrint('NOTIFICATION: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return NotificationListModel(
          status: 'failed',
          data: null,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('NOTIFICATION ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return NotificationListModel(
        status: 'failed',
        data: null,
      );
    }
  }
}
