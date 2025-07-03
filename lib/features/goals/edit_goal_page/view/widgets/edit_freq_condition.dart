import 'package:growk_v2/views.dart';

Widget editFreqConditon(
    WidgetRef ref,
    String selectedFrequency,
    MaterialColor highlightColor,
    bool isDark,
    int calculatedYear,
    double calculatedAmount,
    double dailyAmount,
    double weeklyAmount,
    double monthlyAmount) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.sarSymbol,
                height: 12,
                color: selectedFrequency == 'Daily'
                    ? highlightColor
                    : isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
              ),
              Text(
                ' ${dailyAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: selectedFrequency == 'Daily'
                      ? highlightColor
                      : isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.sarSymbol,
                height: 12,
                color: selectedFrequency == 'Weekly'
                    ? highlightColor
                    : isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
              ),
              Text(
                ' ${weeklyAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: selectedFrequency == 'Weekly'
                      ? highlightColor
                      : isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.sarSymbol,
                height: 12,
                color: selectedFrequency == 'Monthly'
                    ? highlightColor
                    : isDark
                        ? Colors.grey[400]
                        : Colors.grey[600],
              ),
              Text(
                ' ${monthlyAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: selectedFrequency == 'Monthly'
                      ? highlightColor
                      : isDark
                          ? Colors.grey[400]
                          : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
