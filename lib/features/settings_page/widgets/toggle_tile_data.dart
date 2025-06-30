import 'package:growk_v2/views.dart';

Widget buildSettingsToggleTile(
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
