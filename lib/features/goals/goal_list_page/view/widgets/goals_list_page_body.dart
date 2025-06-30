import 'package:growk_v2/features/goals/add_goal_page/view/widget/goals_header.dart';
import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/features/goals/goal_list_page/view/widgets/build_goals_content.dart';
import 'package:growk_v2/views.dart';

Widget goalsListPageBody(bool isDark, WidgetRef ref) {
  final goalListState = ref.watch(goalListStateProvider);
  return Container(
    color: isDark ? Colors.black : Colors.white,
    child: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref.read(goalListStateProvider.notifier).refreshGoals();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GoalsHeader(),
              Container(
                color: AppColors.current(isDark).scaffoldBackground,
                height: 5,
              ),
              goalsContentBuilder(goalListState, isDark),
            ],
          ),
        ),
      ),
    ),
  );
}
