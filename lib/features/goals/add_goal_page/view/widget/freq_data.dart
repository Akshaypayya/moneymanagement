import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/views.dart';

Widget freqTitle(String title, Color textColor) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.poppins().fontFamily,
      color: textColor,
    ),
  );
}

Widget dailyExpanded(WidgetRef ref, String selectedFrequency,
    MaterialColor highlightColor, bool isDark, Color textColor) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        ref.read(frequencyProvider.notifier).state = 'Daily';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selectedFrequency == 'Daily'
              ? highlightColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedFrequency == 'Daily'
                ? highlightColor
                : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            'Daily',
            style: TextStyle(
              fontSize: 13,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: selectedFrequency == 'Daily' ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget weeklyExpanded(WidgetRef ref, String selectedFrequency,
    MaterialColor highlightColor, bool isDark, Color textColor) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        ref.read(frequencyProvider.notifier).state = 'Weekly';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selectedFrequency == 'Weekly'
              ? highlightColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedFrequency == 'Weekly'
                ? highlightColor
                : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            'Weekly',
            style: TextStyle(
              fontSize: 13,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: selectedFrequency == 'Weekly' ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget monthlyExpanded(WidgetRef ref, String selectedFrequency,
    MaterialColor highlightColor, bool isDark, Color textColor) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        ref.read(frequencyProvider.notifier).state = 'Monthly';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selectedFrequency == 'Monthly'
              ? highlightColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedFrequency == 'Monthly'
                ? highlightColor
                : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            'Monthly',
            style: TextStyle(
              fontSize: 13,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: selectedFrequency == 'Monthly' ? Colors.white : textColor,
            ),
          ),
        ),
      ),
    ),
  );
}
