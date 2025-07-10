import 'package:growk_v2/views.dart';

Widget buildPlaceholder(bool isDark, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.add_photo_alternate_outlined,
        size: 32,
        color: isDark ? Colors.white : Colors.grey[700],
      ),
      const SizedBox(height: 4),
      Text(
        texts.addIcon,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? Colors.white : Colors.grey[700],
        ),
      ),
    ],
  );
}
