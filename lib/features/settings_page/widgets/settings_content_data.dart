import 'package:growk_v2/features/logout/provider/logout_provider.dart';
import 'package:growk_v2/features/settings_page/controller/settings_controller.dart';
import 'package:growk_v2/features/settings_page/widgets/biometric_setting.dart';
import 'package:growk_v2/features/settings_page/widgets/settings_item.dart';
import 'package:growk_v2/features/settings_page/widgets/settings_nav_tile.dart';
import 'package:growk_v2/features/settings_page/widgets/toggle_tile_data.dart';
import 'package:growk_v2/views.dart';

class SettingsContent extends ConsumerWidget {
  const SettingsContent({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isLoggingOut = ref.watch(isLogoutLoadingProvider);
    final textColor = AppColors.current(isDark).text;
    final settingsController = SettingsController();
    return Container(
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
              buildSettingsToggleTile(
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
              buildSettingsNavigationTile(
                context,
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () {
                  settingsController.showGrowkAboutDialog(context, isDark);
                },
                isDark: isDark,
              ),
              SettingsItem(
                onTap: isLoggingOut
                    ? null
                    : () =>
                        settingsController.showLogoutConfirmation(context, ref),
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
    );
  }
}
