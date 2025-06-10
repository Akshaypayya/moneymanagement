import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/notifcation_page/model/notification_model.dart';
import 'package:growk_v2/features/notifcation_page/repo/notification_repo.dart';
import 'package:growk_v2/features/notifcation_page/controller/notification_controller.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return NotificationRepository(networkService, ref);
});

final notificationStateProvider = StateNotifierProvider<
    NotificationStateNotifier, AsyncValue<NotificationListModel>>((ref) {
  return NotificationStateNotifier(ref);
});

final notificationDisplayStartProvider = StateProvider<int>((ref) => 0);
final notificationDisplayLengthProvider = StateProvider<int>((ref) => 20);
final hasMoreNotificationsProvider = StateProvider<bool>((ref) => true);
final isLoadingMoreNotificationsProvider = StateProvider<bool>((ref) => false);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notificationState = ref.watch(notificationStateProvider);
  return notificationState.when(
    data: (model) => model.data?.unreadCount ?? 0,
    loading: () => 0,
    error: (error, stackTrace) => 0,
  );
});
