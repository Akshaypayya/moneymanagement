import 'package:growk_v2/views.dart';

Widget buildSettingsNavigationTile(
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
