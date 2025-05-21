import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';

final notificationEnabledProvider = StateProvider<bool>((ref) => true);

class SettingsItem extends ConsumerWidget {
  final String img;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final bool isSwitch;
  final String itemType;
  final VoidCallback? onTap;

  const SettingsItem({
    Key? key,
    required this.img,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.isSwitch = false,
    this.itemType = '',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isNotificationEnabled = ref.watch(notificationEnabledProvider);
    double iconSpacing = 20.0;
    if (title == 'Notification') {
      iconSpacing = 22.0;
    } else if (title == 'Language') {
      iconSpacing = 10.0;
    } else if (title == 'Theme') {
      iconSpacing = 13.0;
    } else if (title == 'Help') {
      iconSpacing = 18.0;
    } else if (title == 'Terms and Conditions') {
      iconSpacing = 20.0;
    } else if (title == 'Logout') {
      iconSpacing = 13.0;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/$img',
              height: 30,
            ),
            SizedBox(width: iconSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12,
                      fontWeight: FontWeight.w200,
                      color: isDark ? Colors.grey[400] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            if (isSwitch && itemType == 'notification')
              Switch(
                value: isNotificationEnabled,
                onChanged: (value) {
                  ref.read(notificationEnabledProvider.notifier).state = value;
                },
                activeColor: Colors.green,
                activeTrackColor: Colors.green.withOpacity(0.5),
              )
            else if (trailing != null)
              trailing!,
          ],
        ),
      ),
    );
  }
}
