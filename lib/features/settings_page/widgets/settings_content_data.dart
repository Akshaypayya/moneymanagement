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
    final texts = ref.watch(appTextsProvider);

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
                  text: texts.settings,
                  style: AppTextStyle(textColor: textColor).titleRegular,
                ),
              ),
              GapSpace.height20,
              buildSettingsToggleTile(
                context,
                icon: !isDark
                    ? 'settings_notification_light.png'
                    : 'settings_notification_dark.png',
                title: texts.notification,
                subtitle: texts.notificationSubtitle,
                isEnabled: ref.watch(notificationEnabledProvider),
                onChanged: (value) async {
                  ref.read(notificationEnabledProvider.notifier).state = value;
                  await SharedPreferencesHelper.saveBool(
                      'notifications_enabled', value);
                  final notificationService = ref.read(notificationProvider);

                  if (value) {
                    debugPrint(
                        'Notifications toggle ON: Enabling push notifications');

                    await notificationService.requestPermission();
                    await notificationService.initLocalNotifications(
                        context, ref);
                    notificationService.firebaseInit(context, ref);

                    showGrowkSnackBar(
                      context: context,
                      ref: ref,
                      message: texts.notificationsEnabled,
                      type: SnackType.success,
                    );
                  } else {
                    debugPrint(
                        'Notifications toggle OFF: Disabling push notifications');

                    await FirebaseMessaging.instance.deleteToken();
                    notificationService.stopForegroundNotifications();

                    showGrowkSnackBar(
                      context: context,
                      ref: ref,
                      message: 'Notifications disabled',
                      type: SnackType.success,
                    );
                  }
                },
                isDark: isDark,
              ),
              SettingsItem(
                onTap: () {
                  settingsController.showLanguageSheet(context, ref);
                },
                img: !isDark
                    ? 'settings_language_light.png'
                    : 'settings_language_dark.png',
                title: texts.language,
                subtitle: texts.languageSubtitle,
                trailing: Text(
                  ref.watch(languageNameProvider),
                  // ref.watch(localeProvider).languageCode == 'en'
                  //     ? texts.english
                  //     : texts.arabic,
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
                title: texts.theme,
                subtitle: texts.themeSubtitle,
                isEnabled: isDark,
                onChanged: (value) {
                  ref.read(isDarkProvider.notifier).state = value;
                  SharedPreferencesHelper.saveBool('isDark', value);
                  debugPrint('theme is:$value');
                },
                // onChanged: (value) {
                //   ref.read(isDarkProvider.notifier).state = value;
                //   debugPrint('theme is:$value');
                // },
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
                title: texts.faq,
                subtitle: texts.faqSubtitle,
              ),
              SettingsItem(
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.termsAndConditions);
                },
                img: !isDark
                    ? 'settings_terms_light.png'
                    : 'settings_terms_dark.png',
                title: texts.termsAndConditions,
                subtitle: texts.termsSubtitle,
              ),
              buildSettingsNavigationTile(
                context,
                icon: Icons.info_outline,
                title: texts.about,
                subtitle: texts.aboutSubtitle,
                onTap: () {
                  settingsController.showGrowkAboutDialog(context, isDark, ref);
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
                title: texts.logout,
                subtitle: texts.logoutSubtitle,
              ),
              const SizedBox(height: 130),
            ],
          ),
        ),
      ),
    );
  }
}
