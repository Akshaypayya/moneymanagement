import 'package:growk_v2/features/goals/goal_detail_page/controller/goals_funds_controller.dart';
import 'package:growk_v2/views.dart';

Widget buildQuickAmountButtons(bool isDark, LoadFundsController controller,
    TextEditingController amountController) {
  final quickAmounts = ['100', '500', '1000', '5000'];

  return Row(
    children: quickAmounts.map((amount) {
      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            right:
                quickAmounts.indexOf(amount) == quickAmounts.length - 1 ? 0 : 8,
          ),
          child: GestureDetector(
            onTap: () {
              controller.updateLoadAmount(amount);
              amountController.text = amount;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                  width: 1,
                ),
                color: amountController.text == amount
                    ? Colors.teal
                    : Colors.transparent,
              ),
              child: Center(
                child: Text(
                  amount,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark
                        ? Colors.grey[300]
                        : amountController.text == amount
                            ? Colors.white
                            : Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList(),
  );
}
