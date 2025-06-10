import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/notifcation_page/model/notification_model.dart';

class NotificationItemWidget extends ConsumerWidget {
  final NotificationItem notification;

  const NotificationItemWidget({
    Key? key,
    required this.notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    bool titleNeedsSymbol =
        notification.displayTitle.trim().startsWith('5000') ||
            notification.displayTitle.toLowerCase().contains('sar') ||
            _containsAmount(notification.displayTitle);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark
                ? Colors.grey.shade800.withOpacity(0.5)
                : Colors.grey.shade200,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                notification.iconAsset,
                width: 30,
                height: 30,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.notifications,
                    size: 30,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleNeedsSymbol
                    ? Row(
                        children: [
                          Image.asset(AppImages.sarSymbol,
                              height: 14,
                              color: AppColors.current(isDark).primary),
                          Text(
                            notification.displayTitle,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        notification.displayTitle,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column(
                    //   children: [
                    //     const SizedBox(
                    //       height: 2,
                    //     ),
                    //     Image.asset(AppImages.sarSymbol,
                    //         height: 13,
                    //         color: AppColors.current(isDark).primary),
                    //   ],
                    // ),
                    // const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        notification.displayMessage,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: isDark ? Colors.grey[400] : Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    notification.formattedTime,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _containsAmount(String text) {
    return RegExp(r'\d+').hasMatch(text) &&
        (text.toLowerCase().contains('converted') ||
            text.toLowerCase().contains('amount') ||
            text.toLowerCase().contains('deposited') ||
            text.toLowerCase().contains('credited'));
  }
}
