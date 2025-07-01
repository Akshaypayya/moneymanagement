import 'package:growk_v2/features/goals/add_goal_page/view/add_goal_page.dart';
import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/views.dart';

FloatingActionButton goalsFab(BuildContext context, WidgetRef ref) {
  final isDark = ref.watch(isDarkProvider);
  return FloatingActionButton(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100),
    ),
    onPressed: () async {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreateGoalPage()),
      );
      if (context.mounted) {
        ref.read(goalListStateProvider.notifier).refreshGoals();
      }
    },
    backgroundColor: isDark ? Colors.white : Colors.black,
    child: Icon(
      Icons.add,
      color: isDark ? Colors.black : Colors.white,
    ),
  );
}
