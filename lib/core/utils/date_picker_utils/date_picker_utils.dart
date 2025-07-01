import 'package:intl/intl.dart';
import '../../../views.dart';

class DatePickerUtils {
  static Future<DateTime?> showThemedDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required WidgetRef ref,
  }) async {
    final isDark = ref.watch(isDarkProvider);
    final textStyle = AppTextStyle.current(isDark);
    final colorScheme = AppColors.current(isDark);

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? ColorScheme.dark(
              primary: colorScheme.primary,
              onPrimary: colorScheme.background,
              surface: colorScheme.background,
              onSurface: colorScheme.text,
            )
                : ColorScheme.light(
              primary: colorScheme.primary,
              onPrimary: colorScheme.background,
              surface: colorScheme.background,
              onSurface: colorScheme.text,
            ),
            dialogBackgroundColor: colorScheme.background,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
                textStyle: textStyle.titleSmall,
              ),
            ),
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  static String formatDate(DateTime date) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    return DateFormat('yyyy-MM-dd').format(normalizedDate);
  }
}
