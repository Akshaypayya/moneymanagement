// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
// import 'package:growk_v2/core/theme/app_theme.dart';
// import 'package:growk_v2/core/widgets/growk_app_bar.dart';
// import 'package:growk_v2/features/notifcation_page/model/notification_model.dart';
// import 'package:growk_v2/features/notifcation_page/provider/notification_provider.dart';
// import 'package:growk_v2/features/notifcation_page/view/widgets/notification_item_widget.dart';

// class NotificationsPage extends ConsumerStatefulWidget {
//   const NotificationsPage({Key? key}) : super(key: key);

//   @override
//   ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
// }

// class _NotificationsPageState extends ConsumerState<NotificationsPage> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_scrollListener);
//   }

//   @override
//   void dispose() {
//     _scrollController.removeListener(_scrollListener);
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200) {
//       ref.read(notificationStateProvider.notifier).loadMoreNotifications();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = ref.watch(isDarkProvider);
//     final notificationState = ref.watch(notificationStateProvider);
//     final isLoadingMore = ref.watch(isLoadingMoreNotificationsProvider);

//     return ScalingFactor(
//       child: Scaffold(
//         backgroundColor: isDark ? Colors.black : Colors.white,
//         appBar: GrowkAppBar(
//           title: 'Notifications',
//           isBackBtnNeeded: true,
//         ),
//         body: SafeArea(
//           child: notificationState.when(
//             loading: () => _buildLoadingState(isDark),
//             error: (error, stackTrace) =>
//                 _buildErrorState(error.toString(), isDark),
//             data: (notificationModel) => _buildNotificationList(
//               notificationModel,
//               isDark,
//               isLoadingMore,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLoadingState(bool isDark) {
//     return Center(
//       child: CircularProgressIndicator(
//         color: isDark ? Colors.white : Colors.black,
//       ),
//     );
//   }

//   Widget _buildErrorState(String error, bool isDark) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.error_outline,
//               size: 64,
//               color: isDark ? Colors.red[300] : Colors.red,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'Failed to load notifications',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.black,
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 ref
//                     .read(notificationStateProvider.notifier)
//                     .refreshNotifications();
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.teal,
//                 foregroundColor: Colors.white,
//               ),
//               child: Text(
//                 'Retry',
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.poppins().fontFamily,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNotificationList(
//     NotificationListModel notificationModel,
//     bool isDark,
//     bool isLoadingMore,
//   ) {
//     if (notificationModel.data == null ||
//         notificationModel.data!.aaData.isEmpty) {
//       return _buildEmptyState(isDark);
//     }

//     final notifications = notificationModel.data!.aaData;

//     // return RefreshIndicator(
//     //   onRefresh: () async {
//     //     await ref
//     //         .read(notificationStateProvider.notifier)
//     //         .refreshNotifications();
//     //   },
//     //   child: Column(
//     //     children: [
//     //       Expanded(
//     //         child: ListView.builder(
//     //           controller: _scrollController,
//     //           itemCount: notifications.length + (isLoadingMore ? 1 : 0),
//     //           itemBuilder: (context, index) {
//     //             if (index == notifications.length) {
//     //               return Container(
//     //                 padding: const EdgeInsets.all(16),
//     //                 alignment: Alignment.center,
//     //                 child: CircularProgressIndicator(
//     //                   color: isDark ? Colors.white : Colors.black,
//     //                 ),
//     //               );
//     //             }

//     //             final notification = notifications[index];
//     //             return NotificationItemWidget(notification: notification);
//     //           },
//     //         ),
//     //       ),
//     //     ],
//     //   ),
//     // );
//     return RefreshIndicator(
//       onRefresh: () async {
//         await ref
//             .read(notificationStateProvider.notifier)
//             .refreshNotifications();
//       },
//       child: ListView.builder(
//         controller: _scrollController,
//         physics: const AlwaysScrollableScrollPhysics(),
//         itemCount: notifications.length + (isLoadingMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index == notifications.length) {
//             return Container(
//               padding: const EdgeInsets.all(16),
//               alignment: Alignment.center,
//               child: CircularProgressIndicator(
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//             );
//           }

//           final notification = notifications[index];
//           return NotificationItemWidget(notification: notification);
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState(bool isDark) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.notifications_none,
//               size: 64,
//               color: isDark ? Colors.grey[400] : Colors.grey[600],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No Notifications',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.black,
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//               ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'You\'re all caught up! New notifications will appear here.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.grey[300] : Colors.grey[600],
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/features/notifcation_page/model/notification_model.dart';
import 'package:growk_v2/features/notifcation_page/provider/notification_provider.dart';
import 'package:growk_v2/features/notifcation_page/view/widgets/notification_item_widget.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(notificationStateProvider.notifier).loadMoreNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final notificationState = ref.watch(notificationStateProvider);
    final isLoadingMore = ref.watch(isLoadingMoreNotificationsProvider);

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: GrowkAppBar(
          title: 'Notifications',
          isBackBtnNeeded: true,
        ),
        body: RefreshIndicator(
          onRefresh: () {
            return ref
                .read(notificationStateProvider.notifier)
                .refreshNotifications();
          },
          child: SafeArea(
            child: notificationState.when(
              loading: () => _buildLoadingState(isDark),
              error: (error, stackTrace) =>
                  _buildErrorState(error.toString(), isDark),
              data: (notificationModel) => _buildNotificationList(
                notificationModel,
                isDark,
                isLoadingMore,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: CircularProgressIndicator(
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(
            //   Icons.error_outline,
            //   size: 64,
            //   color: isDark ? Colors.red[300] : Colors.red,
            // ),
            Icon(
              Icons.receipt_long_outlined,
              size: 80,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Notification Found Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
            const SizedBox(height: 16),
            // ElevatedButton(
            //   onPressed: () {
            //     ref
            //         .read(notificationStateProvider.notifier)
            //         .refreshNotifications();
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.teal,
            //     foregroundColor: Colors.white,
            //   ),
            //   child: Text(
            //     'Retry',
            //     style: TextStyle(
            //       fontFamily: GoogleFonts.poppins().fontFamily,
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
    NotificationListModel notificationModel,
    bool isDark,
    bool isLoadingMore,
  ) {
    // UPDATED: Check for empty notifications and show appropriate empty state
    if (notificationModel.data == null ||
        notificationModel.data!.aaData.isEmpty) {
      debugPrint(
          "NOTIFICATIONS PAGE: Displaying empty state - no notifications made yet");
      return _buildEmptyState(isDark);
    }

    final notifications = notificationModel.data!.aaData;

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(notificationStateProvider.notifier)
            .refreshNotifications();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: notifications.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == notifications.length) {
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                color: isDark ? Colors.white : Colors.black,
              ),
            );
          }

          final notification = notifications[index];
          return NotificationItemWidget(notification: notification);
        },
      ),
    );
  }

  // UPDATED: Enhanced empty state for notifications
  Widget _buildEmptyState(bool isDark) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(notificationStateProvider.notifier)
            .refreshNotifications();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Empty state illustration
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.grey[800]?.withOpacity(0.3)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(60),
                    ),
                    child: Icon(
                      Icons.notifications_none_outlined,
                      size: 60,
                      color: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Main title
                  Text(
                    'No Notifications Made Yet',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Description text
                  Text(
                    'You\'re all caught up! New notifications about your goals, transactions, and account updates will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.grey[300] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Call to action
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.blue.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Stay tuned for updates!',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
