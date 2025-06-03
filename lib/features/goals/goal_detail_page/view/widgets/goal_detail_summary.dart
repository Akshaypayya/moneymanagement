import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_summary_controller.dart';

class GoalSummary extends ConsumerWidget {
  final String amount;
  final String profit;
  final String currentGold;
  final String virtualAccountNbr;
  final String currentGoldPrice;
  final String invested;
  final String goalStatus;

  const GoalSummary({
    Key? key,
    required this.amount,
    required this.profit,
    required this.currentGold,
    required this.virtualAccountNbr,
    required this.currentGoldPrice,
    required this.invested,
    required this.goalStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;
    final controller = ref.read(goalSummaryControllerProvider);

    final profitValue = controller.getProfitValue(amount, invested);
    final formattedProfit = controller.getFormattedProfit(profitValue);
    final isProfitNegative = controller.isProfitNegative(profitValue);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.sarSymbol,
                height: 20,
                color: AppColors.current(isDark).primary,
              ),
              const SizedBox(width: 5),
              ReusableText(
                text: amount,
                style: AppTextStyle(textColor: textColor).titleMedium,
              ),
              const SizedBox(width: 8),
              goalStatus == "COMPLETED"
                  ? const SizedBox()
                  : _buildProfitSection(
                      isDark, formattedProfit, isProfitNegative),
            ],
          ),
          const SizedBox(height: 8),
          _buildGoldHoldingsSection(isDark),
          // const SizedBox(height: 8),
          // _buildVirtualAccountSection(context, ref, isDark, controller),
        ],
      ),
    );
  }

  Widget _buildProfitSection(
      bool isDark, String formattedProfit, bool isProfitNegative) {
    final profitColor = isProfitNegative ? Colors.red : Colors.green;

    return Row(
      children: [
        Text(
          '(Profit: ',
          style: TextStyle(
            fontSize: 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Image.asset(
          AppImages.sarSymbol,
          height: 13,
          color: profitColor,
        ),
        if (isProfitNegative) GapSpace.width5,
        Text(
          formattedProfit,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: profitColor,
          ),
        ),
        Text(
          ')',
          style: TextStyle(
            fontSize: 12,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildGoldHoldingsSection(bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Current Gold Holdings: ',
          style: TextStyle(
            fontSize: 14,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.grey[300] : Colors.grey[800],
          ),
        ),
        Text(
          currentGold,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        GapSpace.width5,
        Row(
          children: [
            Text(
              '(',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Image.asset(
              AppImages.sarSymbol,
              height: 13,
            ),
            GapSpace.width5,
            Text(
              '${double.tryParse(currentGoldPrice)?.toStringAsFixed(2) ?? currentGoldPrice})',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildVirtualAccountSection(BuildContext context, WidgetRef ref,
  //     bool isDark, GoalSummaryController controller) {
  //   return GestureDetector(
  // onTap: () => controller.copyVirtualAccountToClipboard(
  //     context, virtualAccountNbr, ref),
  //     child: Row(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Text(
  //           'Virtual Account: ',
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontFamily: GoogleFonts.poppins().fontFamily,
  //             color: isDark ? Colors.grey[300] : Colors.grey[800],
  //           ),
  //         ),
  //         Text(
  //           virtualAccountNbr,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold,
  //             fontFamily: GoogleFonts.poppins().fontFamily,
  //             color: isDark ? Colors.white : Colors.black,
  //           ),
  //         ),
  //         const SizedBox(width: 5),
  //         Icon(
  //           Icons.copy,
  //           size: 16,
  //           color: isDark ? Colors.grey[400] : Colors.grey[600],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
