import 'package:growk_v2/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:growk_v2/features/goals/goal_list_page/view/widgets/goals_list_content.dart';
import 'package:growk_v2/views.dart';

Widget goalsContentBuilder(
    AsyncValue<GoalListModel> goalListState, bool isDark) {
  return goalListState.when(
    loading: () => const SizedBox.shrink(),
    error: (error, stackTrace) => const SizedBox.shrink(),
    data: (goalListModel) => goalsDataContent(goalListModel, isDark),
  );
}
