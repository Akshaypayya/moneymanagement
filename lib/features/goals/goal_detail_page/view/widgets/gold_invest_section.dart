import 'package:growk_v2/views.dart';

Widget buildGoalInvestmentSection(bool isDark, String goldInvestmentStatus) {
  return Center(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Auto Gold Purchase: ',
          style: TextStyle(
            fontSize: 14,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
        Text(
          goldInvestmentStatus == "Y" ? "Enabled" : "Disabled",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    ),
  );
}
