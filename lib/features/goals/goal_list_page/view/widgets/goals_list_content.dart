import 'package:growk_v2/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:growk_v2/features/goals/goal_list_page/view/widgets/goal_item.dart';
import 'package:growk_v2/views.dart';

Widget goalsDataContent(GoalListModel goalListModel, bool isDark) {
  return Column(
    children: goalListModel.data.asMap().entries.map((entry) {
      final index = entry.key;
      final goal = entry.value;
      final isLast = index == goalListModel.data.length - 1;
      debugPrint('Virtual ID :${goal.goalName} : ${goal.linkedVA}');

      return GoalItem(
        iconAsset: goal.goalPic,
        iconWidget: goal.getIconWidget(width: 35, height: 35),
        title: goal.goalName,
        amount: goal.formattedAvailableBalance,
        profit: goal.formattedProfit,
        currentGold: '${goal.formattedGoldBalance} gm',
        // invested: goal.investedAmount.toString(),
        invested: goal.formattedInvestedAmount,
        target: goal.formattedTargetAmount,
        progress: goal.progressText,
        progressPercent: goal.progressPercent,
        isLast: isLast,
        goalStatus: goal.status,
      );
    }).toList(),
  );
}
