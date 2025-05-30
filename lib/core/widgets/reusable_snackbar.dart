import 'package:growk_v2/views.dart';

enum SnackType { success, error }

void showGrowkSnackBar({
  required BuildContext context,
  required WidgetRef ref,
  required String message,
  required SnackType type,
}) {
  final isDark = ref.watch(isDarkProvider);
  final icon = type == SnackType.success ? Icons.check_circle : Icons.error;
  final iconColor = type == SnackType.success ? Colors.green : Colors.red;
  final bgColor = isDark ? const Color(0xFF2B2B2B) : Colors.white;
  final textColor = isDark ? Colors.white : Colors.black;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: bgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      elevation: 6,
      content: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: ReusableText(
              maxLines: 5,
              text: message,
              style: AppTextStyle(textColor: textColor).bodyMedium,
            ),
          ),
        ],
      ),
    ),
  );
}
