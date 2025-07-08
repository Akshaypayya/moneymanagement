import 'package:growk_v2/features/logout/provider/logout_provider.dart';
import 'package:growk_v2/views.dart';

final languageNameProvider = StateProvider<String>((ref) => 'English');

class SettingsController {
  void showGrowkAboutDialog(BuildContext context, bool isDark, WidgetRef ref) {
    final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;

    final texts = ref.watch(appTextsProvider);
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
                  texts.growkVersion,
                  style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black87,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  texts.growkVersionSubtitle,
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  texts.growkDescription,
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

  void showLanguageSheet(BuildContext context, WidgetRef ref) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommonBottomSheet(
        showSearch: false,
        title: 'Select Language',
        options: ['English', 'Arabic'],
        onSelected: (value) {
          if (value == 'English') {
            ref.read(localeProvider.notifier).state = const Locale('en');
            ref.read(languageNameProvider.notifier).state = 'English';
          } else if (value == 'Arabic') {
            ref.read(localeProvider.notifier).state = const Locale('ar');
            ref.read(languageNameProvider.notifier).state = 'Arabic';
          }
        },
      ),
    );
  }

  void showLogoutConfirmation(BuildContext context, WidgetRef ref) {
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
              backgroundColor: isDark ? Colors.white : Colors.black,
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
