import 'package:growk_v2/views.dart';

Widget buildGoldHoldingsSection(
    bool isDark, String currentGold, String currentGoldPrice) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'Current Gold Holdings: ',
        style: TextStyle(
          fontSize: 14,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.grey[300] : Colors.grey[800],
        ),
      ),
      Text(
        currentGold,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      GapSpace.width5,
      Row(
        children: [
          Text(
            '(',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Image.asset(
            AppImages.sarSymbol,
            height: 13,
            color: AppColors.current(isDark).primary,
          ),
          GapSpace.width5,
          Text(
            '${double.tryParse(currentGoldPrice)?.toStringAsFixed(2) ?? currentGoldPrice})',
            style: TextStyle(
              fontSize: 14,
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
