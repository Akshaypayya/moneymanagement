import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/views.dart';

Widget editFreqTitle(String title, bool isDark) {
  return Text(
    title,
    style: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.poppins().fontFamily,
      color: isDark ? Colors.white : Colors.black,
    ),
  );
}

Widget editDailyExpanded(WidgetRef ref, String selectedFrequency, bool isDark) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        ref.read(editFrequencyProvider.notifier).state = 'Daily';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              selectedFrequency == 'Daily' ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedFrequency == 'Daily'
                ? Colors.teal
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
              color: selectedFrequency == 'Daily'
                  ? Colors.white
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget editWeeklyExpanded(
    WidgetRef ref, String selectedFrequency, bool isDark) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        ref.read(editFrequencyProvider.notifier).state = 'Weekly';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              selectedFrequency == 'Weekly' ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedFrequency == 'Weekly'
                ? Colors.teal
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
              color: selectedFrequency == 'Weekly'
                  ? Colors.white
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget editMonthlyExpanded(
    WidgetRef ref, String selectedFrequency, bool isDark) {
  return Expanded(
    child: GestureDetector(
      onTap: () {
        ref.read(editFrequencyProvider.notifier).state = 'Monthly';
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color:
              selectedFrequency == 'Monthly' ? Colors.teal : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selectedFrequency == 'Monthly'
                ? Colors.teal
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
              color: selectedFrequency == 'Monthly'
                  ? Colors.white
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ),
      ),
    ),
  );
}
