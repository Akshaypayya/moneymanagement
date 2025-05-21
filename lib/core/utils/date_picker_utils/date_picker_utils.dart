import 'package:intl/intl.dart';
import '../../../views.dart';

class DatePickerUtils {
  static Future<DateTime?> showThemedDatePicker({
    required BuildContext context,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = AppTextStyle.current(isDark);
    final colorScheme = AppColors.current(isDark);

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorScheme.primary,
              onPrimary: Colors.white,
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
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
