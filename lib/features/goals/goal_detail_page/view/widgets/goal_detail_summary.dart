import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_summary_controller.dart';

import 'package:growk_v2/views.dart';

class GoalSummary extends ConsumerWidget {
  final String amount;
  final String profit;
  final String currentGold;
  final String virtualAccountNbr;
  final String currentGoldPrice;
  final String invested;
  final String goalStatus;
  final String goldInvestmentStatus;

  const GoalSummary({
    Key? key,
    required this.amount,
    required this.profit,
    required this.currentGold,
    required this.virtualAccountNbr,
    required this.currentGoldPrice,
    required this.invested,
    required this.goalStatus,
    required this.goldInvestmentStatus,
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
                  : buildProfitSection(
                      isDark, formattedProfit, isProfitNegative),
            ],
          ),
          const SizedBox(height: 8),
          buildGoldHoldingsSection(isDark, currentGold, currentGoldPrice),
          const SizedBox(height: 8),
          buildGoalInvestmentSection(isDark, goldInvestmentStatus),
          // _buildVirtualAccountSection(context, ref, isDark, controller),
        ],
      ),
    );
  }
}
