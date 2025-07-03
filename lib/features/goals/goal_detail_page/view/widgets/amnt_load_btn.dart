import 'package:growk_v2/features/goals/goal_detail_page/controller/goals_funds_controller.dart';
import 'package:growk_v2/views.dart';

Widget buildLoadAmountButton(
  BuildContext context,
  bool isDark,
  LoadFundsController controller,
  bool isLoading,
  TextEditingController amountController,
  WidgetRef ref,
  String goalName,
  VoidCallback? onSuccess,
) {
  return Center(
    child: SizedBox(
      height: 45,
      width: 250,
      child: ElevatedButton(
        onPressed: isLoading
            ? null
            : () {
                if (amountController.text.trim().isEmpty) {
                  Navigator.pop(context);
                  showGrowkSnackBar(
                      context: context,
                      ref: ref,
                      message: 'Enter any amount to load',
                      type: SnackType.error);

                  return;
                }
                controller.loadFunds(
                  context,
                  goalName ?? '',
                  ref,
                  onSuccess: onSuccess,
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isDark ? Colors.white : Colors.black,
                  ),
                ),
              )
            : ReusableText(
                text: 'Load Fund',
                style: AppTextStyle(
                  textColor: AppColors.current(isDark).background,
                ).titleSmall),
      ),
    ),
  );
}
