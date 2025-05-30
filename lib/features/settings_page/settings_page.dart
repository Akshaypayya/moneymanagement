import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/services/data_clearing_service.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/features/logout/provider/logout_provider.dart';
import 'package:growk_v2/features/settings_page/widgets/biometric_setting.dart';
import 'package:growk_v2/features/settings_page/widgets/settings_item.dart';
import 'package:growk_v2/routes/app_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isLoggingOut = ref.watch(isLogoutLoadingProvider);
    final textColor = AppColors.current(isDark).text;
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        // appBar: GrowkAppBar(title: 'Settings', isBackBtnNeeded: false),
        body: Container(
          color: isDark ? Colors.black : Colors.white,
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GapSpace.height12,
                  Center(
                    child: ReusableText(
                      text: 'Settings',
                      style: AppTextStyle(textColor: textColor).titleRegular,
                    ),
                  ),
                  GapSpace.height20,
                  SettingsItem(
                    onTap: () {},
                    img: !isDark
                        ? 'settings_notification_light.png'
                        : 'settings_notification_dark.png',
                    title: 'Notification',
                    subtitle:
                        'Manage alerts and stay updated\non your savings progress.',
                    isSwitch: true,
                    itemType: 'notification',
                  ),
                  SettingsItem(
                    onTap: () {},
                    img: !isDark
                        ? 'settings_language_light.png'
                        : 'settings_language_dark.png',
                    title: 'Language',
                    subtitle:
                        'Select your preferred language\nfor anbetter experience.',
                    trailing: Text(
                      'English',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  _buildToggleTile(
                    context,
                    icon: !isDark
                        ? 'settings_theme_light.png'
                        : 'settings_theme_dark.png',
                    title: 'Theme',
                    subtitle: 'Customize the app\'s look to\nmatch your style.',
                    isEnabled: isDark,
                    onChanged: (value) {
                      ref.read(isDarkProvider.notifier).state = value;
                      debugPrint('theme is:$value');
                    },
                    isDark: isDark,
                  ),
                  const BiometricSettingsTile(),
                  SettingsItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.help);
                    },
                    img: !isDark
                        ? 'settings_help_light.png'
                        : 'settings_help_dark.png',
                    title: 'FAQ',
                    subtitle:
                        'Need assistance? Find answers to your questions here.',
                  ),
                  SettingsItem(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.termsAndConditions);
                    },
                    img: !isDark
                        ? 'settings_terms_light.png'
                        : 'settings_terms_dark.png',
                    title: 'Terms and Conditions',
                    subtitle:
                        'Review the guidelines and policies of using this app.',
                  ),
                  _buildNavigationTile(
                    context,
                    icon: Icons.info_outline,
                    title: 'About',
                    subtitle: 'App version and information',
                    onTap: () {
                      _showAboutDialog(context, isDark);
                    },
                    isDark: isDark,
                  ),
                  SettingsItem(
                    onTap: isLoggingOut
                        ? null
                        : () => _showLogoutConfirmation(context, ref),
                    img: !isDark
                        ? 'settings_logout_light.png'
                        : 'settings_logout_dark.png',
                    title: 'Logout',
                    subtitle: 'Sign out securely from your account.',
                  ),
                  const SizedBox(height: 130),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required bool isEnabled,
    required ValueChanged<bool> onChanged,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      // decoration: BoxDecoration(
      //   color: isDark ? Colors.grey.shade900 : Colors.white,
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/$icon',
                height: 30,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
            ],
          ),
          Switch.adaptive(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: Colors.teal,
            activeTrackColor: Colors.teal.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
    bool isDestructive = false,
  }) {
    final textColor =
        isDestructive ? Colors.red : (isDark ? Colors.white : Colors.black);

    final subtitleColor = isDestructive
        ? Colors.red.withOpacity(0.7)
        : (isDark ? Colors.grey[400] : Colors.grey[600]);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        // decoration: BoxDecoration(
        //   color: isDark ? Colors.grey.shade900 : Colors.white,
        //   border: Border(
        //     bottom: BorderSide(
        //       color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        //       width: 1,
        //     ),
        //   ),
        // ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: textColor,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          'Logout Confirmation',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
            fontSize: 14,
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.black : Colors.white,
                fontSize: 14,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref.read(logoutControllerProvider).logout(context, ref);
            },
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, bool isDark) {
    final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  logoPath,
                  width: 100,
                  height: 60,
                ),
                Text(
                  'v 1.0.0',
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  '© 2025 GrowK. All rights reserved.',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'A secure money management application for tracking finances, setting goals, and investing in gold.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
