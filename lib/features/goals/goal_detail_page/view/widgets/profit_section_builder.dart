import 'package:growk_v2/views.dart';

Widget buildProfitSection(
    bool isDark, String formattedProfit, bool isProfitNegative) {
  final profitColor = isProfitNegative ? Colors.red : Colors.green;

  return Row(
    children: [
      Text(
        '(Profit: ',
        style: TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      Image.asset(
        AppImages.sarSymbol,
        height: 13,
        color: profitColor,
      ),
      if (isProfitNegative) GapSpace.width5,
      Text(
        ' $formattedProfit',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: profitColor,
        ),
      ),
      Text(
        ')',
        style: TextStyle(
          fontSize: 12,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
    ],
  );
}
