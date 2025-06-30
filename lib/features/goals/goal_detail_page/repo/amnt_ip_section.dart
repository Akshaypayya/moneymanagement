import 'package:flutter/services.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goals_funds_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/quick_amnt_btns.dart';
import 'package:growk_v2/views.dart';

Widget buildAmountInputSection(bool isDark, LoadFundsController controller,
    TextEditingController amountController, FocusNode amountFocusNode) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Enter Amount',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
            width: 1,
          ),
          color: isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[50],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.sarSymbol,
                    height: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 1,
                    height: 20,
                    color: isDark ? Colors.grey[600] : Colors.grey[300],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TextField(
                controller: amountController,
                focusNode: amountFocusNode,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^[0-9]*\.?[0-9]*')),
                  LengthLimitingTextInputFormatter(10),
                ],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[400],
                    fontWeight: FontWeight.normal,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                ),
                onChanged: (value) {
                  controller.updateLoadAmount(value);
                },
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      buildQuickAmountButtons(isDark, controller, amountController),
    ],
  );
}
