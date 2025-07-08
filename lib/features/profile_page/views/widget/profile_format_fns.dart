import 'package:growk_v2/views.dart';
import 'package:intl/intl.dart';

String profileFormatDate(String? dateStr) {
  if (dateStr == null || dateStr.isEmpty) return 'Not available';

  try {
    final DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd MMMM yyyy').format(date);
  } catch (e) {
    return dateStr;
  }
}

String profileFormatGender(String? gender, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  if (gender == null || gender.isEmpty) return 'Not specified';

  switch (gender.toUpperCase()) {
    case 'M':
      return texts.male;
    case 'F':
      return texts.female;
    case 'T':
      return texts.other;
    default:
      return texts.gender;
  }
}

Widget buildLoadingItem(bool isDark) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: 80,
        height: 16,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(height: 6),
      Container(
        width: 150,
        height: 16,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[700] : Colors.grey[300],
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ],
  );
}
