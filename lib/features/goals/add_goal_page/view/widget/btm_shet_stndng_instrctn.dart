import 'package:growk_v2/features/goals/add_goal_page/view/widget/stnding_instrction_botom_sheet.dart';
import 'package:growk_v2/views.dart';

void showStandingInstructionBottomSheet(
    BuildContext context,
    String virtualAccount,
    double transactionAmount,
    String frequency,
    String goalName,
    {VoidCallback? onClose}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.transparent,
    builder: (context) => StandingInstructionBottomSheet(
      virtualAccount: virtualAccount,
      transactionAmount: transactionAmount,
      frequency: frequency,
      goalName: goalName,
      onClose: onClose,
    ),
  );
}
