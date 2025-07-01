import 'package:growk_v2/features/logout/provider/logout_provider.dart';
import 'package:growk_v2/views.dart';

class SettingsController {
  void showGrowkAboutDialog(BuildContext context, bool isDark) {
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
                  'Start Saving in 24K Digital Gold - From Just 100 SAR or 1 Gram. Turn everyday savings into lasting wealth. With GrowK, you can automate your gold investments starting with as little as 100 SAR.',
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
              backgroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
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
