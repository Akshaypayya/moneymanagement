import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:growk_v2/views.dart';

class UpdateGoalButton extends ConsumerStatefulWidget {
  final GoalData? goalData;
  const UpdateGoalButton({this.goalData, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateGoalButtonState();
}

class _UpdateGoalButtonState extends ConsumerState<UpdateGoalButton> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(editGoalControllerProvider);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () =>
            controller.updateGoal(context, widget.goalData!.goalName),
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.black : Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(
            color: isDark ? Colors.white : Colors.black,
            width: isDark ? 1 : 0,
          ),
        ),
        child: Text(
          'Update Goal',
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
