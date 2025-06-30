import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/features/goals/goal_page_checker/view/widgets/goal_checker_condition.dart';
import 'package:growk_v2/features/goals/goal_page_checker/view/widgets/goal_checker_error_state.dart';
import 'package:growk_v2/features/goals/goal_page_checker/view/widgets/goal_checker_loading.dart';
import 'package:growk_v2/views.dart';

final goalsRefreshTriggerProvider = StateProvider<int>((ref) => 0);

class GoalPageWrapper extends ConsumerStatefulWidget {
  const GoalPageWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalPageWrapper> createState() => _GoalPageWrapperState();
}

class _GoalPageWrapperState extends ConsumerState<GoalPageWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(goalListStateProvider.notifier).getGoalsList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.watch(goalListStateProvider.notifier).refreshGoals();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(goalsRefreshTriggerProvider, (previous, current) {
      if (previous != current) {
        ref.watch(goalListStateProvider.notifier).refreshGoals();
      }
    });

    final goalListState = ref.watch(goalListStateProvider);

    return goalListState.when(
      loading: () => goalCheckerLoadingState(ref),
      error: (error, stackTrace) =>
          goalCheckerErrorState(error.toString(), context, ref),
      data: (goalListModel) => goalCheckerContentChooser(goalListModel, ref),
    );
  }
}
