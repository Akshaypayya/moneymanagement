import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:growk_v2/features/notifcation_page/model/notification_model.dart';
import 'package:growk_v2/features/notifcation_page/provider/notification_provider.dart';

class NotificationStateNotifier
    extends StateNotifier<AsyncValue<NotificationListModel>> {
  final Ref ref;
  List<NotificationItem> _allNotifications = [];

  NotificationStateNotifier(this.ref) : super(const AsyncValue.loading()) {
    getNotifications();
  }

  Future<void> getNotifications({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        state = const AsyncValue.loading();
        _allNotifications.clear();
        ref.read(notificationDisplayStartProvider.notifier).state = 0;
      } else {
        ref.read(isLoadingMoreNotificationsProvider.notifier).state = true;
      }

      final repository = ref.read(notificationRepositoryProvider);
      final displayStart = ref.read(notificationDisplayStartProvider);
      final displayLength = ref.read(notificationDisplayLengthProvider);

      debugPrint('NOTIFICATION CONTROLLER: Loading notifications');
      debugPrint('NOTIFICATION CONTROLLER: Display start: $displayStart');
      debugPrint('NOTIFICATION CONTROLLER: Display length: $displayLength');
      debugPrint('NOTIFICATION CONTROLLER: Load more: $loadMore');

      final notificationModel = await repository.getNotificationList(
        iDisplayStart: displayStart,
        iDisplayLength: displayLength,
      );

      if (notificationModel.isSuccess && notificationModel.data != null) {
        final newNotifications = notificationModel.data!.aaData;

        debugPrint(
            'NOTIFICATION CONTROLLER: Received ${newNotifications.length} notifications');

        if (loadMore) {
          _allNotifications.addAll(newNotifications);
          debugPrint(
              'NOTIFICATION CONTROLLER: Total notifications after loading more: ${_allNotifications.length}');
        } else {
          _allNotifications = newNotifications;
          debugPrint(
              'NOTIFICATION CONTROLLER: Fresh load, total notifications: ${_allNotifications.length}');
        }

        final totalRecords = notificationModel.data!.iTotalRecords;
        final hasMore = _allNotifications.length < totalRecords;
        ref.read(hasMoreNotificationsProvider.notifier).state = hasMore;

        ref.read(notificationDisplayStartProvider.notifier).state =
            displayStart + displayLength;

        debugPrint('NOTIFICATION CONTROLLER: Has more notifications: $hasMore');
        debugPrint('NOTIFICATION CONTROLLER: Total records: $totalRecords');
        debugPrint(
            'NOTIFICATION CONTROLLER: Loaded so far: ${_allNotifications.length}');

        final updatedModel = NotificationListModel(
          status: notificationModel.status,
          data: NotificationListData(
            iTotalRecords: notificationModel.data!.iTotalRecords,
            pageNumber: notificationModel.data!.pageNumber,
            aaData: _allNotifications,
            unreadCount: notificationModel.data!.unreadCount,
            iTotalDisplayRecords: _allNotifications.length,
          ),
        );

        state = AsyncValue.data(updatedModel);
      } else {
        debugPrint('NOTIFICATION CONTROLLER: Failed to load notifications');
        debugPrint(
            'NOTIFICATION CONTROLLER: Status: ${notificationModel.status}');

        if (!loadMore) {
          state = AsyncValue.error(
            notificationModel.status == 'failed'
                ? 'Failed to load notifications'
                : notificationModel.status,
            StackTrace.current,
          );
        }
      }
    } catch (e, stackTrace) {
      debugPrint('NOTIFICATION CONTROLLER ERROR: $e');
      debugPrint('NOTIFICATION CONTROLLER STACK TRACE: $stackTrace');

      if (!loadMore) {
        state = AsyncValue.error(e, stackTrace);
      }
    } finally {
      if (loadMore) {
        ref.read(isLoadingMoreNotificationsProvider.notifier).state = false;
      }
    }
  }

  Future<void> refreshNotifications() async {
    debugPrint('NOTIFICATION CONTROLLER: Refreshing notifications');
    _allNotifications.clear();
    ref.read(notificationDisplayStartProvider.notifier).state = 0;
    ref.read(hasMoreNotificationsProvider.notifier).state = true;
    await getNotifications();
  }

  Future<void> loadMoreNotifications() async {
    final hasMore = ref.read(hasMoreNotificationsProvider);
    final isLoading = ref.read(isLoadingMoreNotificationsProvider);

    debugPrint('NOTIFICATION CONTROLLER: Load more requested');
    debugPrint('NOTIFICATION CONTROLLER: Has more: $hasMore');
    debugPrint('NOTIFICATION CONTROLLER: Is loading: $isLoading');

    if (hasMore && !isLoading) {
      debugPrint('NOTIFICATION CONTROLLER: Loading more notifications');
      await getNotifications(loadMore: true);
    } else {
      debugPrint(
          'NOTIFICATION CONTROLLER: Cannot load more - hasMore: $hasMore, isLoading: $isLoading');
    }
  }

  int get totalNotifications => _allNotifications.length;

  int get unreadCount {
    return state.when(
      data: (model) => model.data?.unreadCount ?? 0,
      loading: () => 0,
      error: (error, stackTrace) => 0,
    );
  }
}
