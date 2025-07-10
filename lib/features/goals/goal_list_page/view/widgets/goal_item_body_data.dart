import 'package:growk_v2/views.dart';

Widget goalItemBodyData(
    WidgetRef ref,
    Widget? iconWidget,
    String iconAsset,
    String title,
    String amount,
    String profit,
    String currentGold,
    String invested,
    String target,
    String progress,
    double progressPercent,
    String goalStatus,
    bool isDark,
    Color textColor) {
  return Column(
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: goalStatus == "COMPLETED"
              ? Colors.grey[300]
              : isDark
                  ? Colors.black
                  : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            goalItemDataRow(ref, iconWidget!, iconAsset, title, amount, profit,
                goalStatus, textColor),
            const SizedBox(height: 15),
            goalItemRow2(currentGold, invested, target, progress,
                progressPercent, goalStatus, isDark, ref)
          ],
        ),
      ),
      Container(
        color: AppColors.current(isDark).scaffoldBackground,
        height: 5,
      ),
    ],
  );
}
