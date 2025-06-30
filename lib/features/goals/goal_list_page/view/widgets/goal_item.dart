import 'package:growk_v2/features/goals/goal_list_page/view/widgets/goal_item_body_data.dart';
import 'package:growk_v2/views.dart';

class GoalItem extends ConsumerWidget {
  final String? iconAsset;
  final String title;
  final String amount;
  final String profit;
  final String currentGold;
  final String invested;
  final String target;
  final String progress;
  final double progressPercent;
  final bool isLast;
  final Widget? iconWidget;
  final String goalStatus;

  GoalItem({
    Key? key,
    this.iconAsset,
    required this.title,
    required this.amount,
    required this.profit,
    required this.currentGold,
    required this.invested,
    required this.target,
    required this.progress,
    required this.progressPercent,
    this.isLast = false,
    this.iconWidget,
    required this.goalStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoalDetailPage(
                  goalName: title,
                  goalIcon: iconAsset,
                  goalStatus: goalStatus,
                  walletBalance: double.tryParse(amount) ?? 0.0,
                  currentGoldPrice: double.tryParse(currentGold) ?? 0.0),
            ),
          );
        },
        child: goalItemBodyData(
            ref,
            iconWidget,
            iconAsset.toString(),
            title,
            amount,
            profit,
            currentGold,
            invested,
            target,
            progress,
            progressPercent,
            goalStatus,
            isDark,
            textColor));
  }
}
