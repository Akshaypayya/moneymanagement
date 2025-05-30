import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/features/notifcation_page/notification_ui_model/notification_ui_model.dart';
import 'package:growk_v2/features/notifcation_page/widgets/notification_item.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    final notifications = [
      NotificationModel(
        icon: 'assets/bhim.png',
        title: ' 5000 Converted to Gold',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/bank.jpg',
        title: ' 5000 Converted to Gold',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/goldbsct.png',
        title: ' 5000 Converted to Gold',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/goldbsct.png',
        title: 'Gold Added to Your Education Goal!',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/bank.jpg',
        title: 'Gold Added to Your Education Goal!',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/bank.jpg',
        title: 'Gold Added to Your Education Goal!',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/goldbsct.png',
        title: 'Gold Added to Your Education Goal!',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
      NotificationModel(
        icon: 'assets/goldbsct.png',
        title: 'Gold Added to Your Education Goal!',
        message:
            ' 5000 has been successfully converted to 0.834g of gold and credited to your \'Education\' goal. Keep saving and stay on track!',
        timestamp: '22 February 2025 15:30 PM',
      ),
    ];

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: GrowkAppBar(
          title: 'Notifications',
          isBackBtnNeeded: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return NotificationItem(notification: notifications[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
