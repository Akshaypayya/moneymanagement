import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/features/logout/provider/logout_provider.dart';
import 'package:money_mangmnt/features/settings_page/widgets/settings_item.dart';
import 'package:money_mangmnt/views.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isLoggingOut = ref.watch(isLogoutLoadingProvider);

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        appBar: GrowkAppBar(title: 'Settings', isBackBtnNeeded: false),
        body: Container(
          color: isDark ? Colors.black : Colors.white,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                SettingsItem(
                  onTap: () {},
                  img: !isDark
                      ? 'settings_theme_light.png'
                      : 'settings_theme_dark.png',
                  title: 'Theme',
                  subtitle: 'Customize the app\'s look to\nmatch your style.',
                  trailing: Text(
                    'Light',
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SettingsItem(
                  onTap: () {},
                  img: !isDark
                      ? 'settings_help_light.png'
                      : 'settings_help_dark.png',
                  title: 'Help',
                  subtitle:
                      'Need assistance? Find answers to your questions here.',
                ),
                SettingsItem(
                  onTap: () {},
                  img: !isDark
                      ? 'settings_terms_light.png'
                      : 'settings_terms_dark.png',
                  title: 'Terms and Conditions',
                  subtitle:
                      'Review the guidelines and policies of using this app.',
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
              ],
            ),
          ),
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
}
