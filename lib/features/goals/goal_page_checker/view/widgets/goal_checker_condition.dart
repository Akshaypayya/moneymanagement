import 'package:growk_v2/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/features/goals/goal_list_page/view/goals_page.dart';
import 'package:growk_v2/features/goals/no_goal_page/no_goal_page.dart';
import 'package:growk_v2/views.dart';

Widget goalCheckerContentChooser(GoalListModel goalListModel, WidgetRef ref) {
  if (goalListModel.data.isEmpty) {
    return NoGoalPage(
      onGoalCreated: () {
        ref.watch(goalListStateProvider.notifier).refreshGoals();
      },
    );
  } else {
    return const GoalsPage();
  }
}
