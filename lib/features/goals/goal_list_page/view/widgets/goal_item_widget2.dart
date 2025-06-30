import 'package:growk_v2/views.dart';

Column goalItemRow2(
  String currentGold,
  String invested,
  String target,
  String progress,
  double progressPercent,
  String goalStatus,
  bool isDark,
) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            'Current Gold Holdings: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
          Text(
            currentGold,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'Invested: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              Image.asset(
                AppImages.sarSymbol,
                height: 13,
                color: AppColors.current(isDark).primary,
              ),
              Text(
                ' $invested',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                'Target: ',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              Image.asset(
                AppImages.sarSymbol,
                height: 13,
                color: AppColors.current(isDark).primary,
              ),
              Text(
                ' $target',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
            ],
          ),
        ],
      ),
      const SizedBox(height: 15),
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: LinearProgressIndicator(
          value: progressPercent,
          minHeight: 10,
          backgroundColor:
              goalStatus == "COMPLETED" ? Colors.white : Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Progress: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            progress,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    ],
  );
}
