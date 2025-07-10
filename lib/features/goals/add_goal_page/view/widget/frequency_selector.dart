import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/common_providers.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/freq_conditn.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/freq_data.dart';

class FrequencySelector extends ConsumerWidget {
  const FrequencySelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final selectedFrequency = ref.watch(frequencyProvider);

    final calculatedYear = ref.watch(calculatedYearProvider);
    final calculatedAmount = ref.watch(calculatedAmountProvider);

    DateTime today = DateTime.now();
    DateTime futureDate = DateTime(calculatedYear, 12, 31);

    // final duration = (calculatedYear - today.year) * 12;

    int duration =
        (futureDate.year - today.year) * 12 + (futureDate.month - today.month);
    if (duration < 1) duration = 1;
    // if (actualDurationInMonths < 1) actualDurationInMonths = 1;

    // final dailyAmount = calculatedAmount / (duration * 30);
    // final weeklyAmount = calculatedAmount / (duration * 4);
    // final monthlyAmount = calculatedAmount / duration;
    int totalDays = futureDate.difference(today).inDays;
    if (totalDays < 1) totalDays = 1;

    int totalWeeks = (totalDays / 7).ceil();
    if (totalWeeks < 1) totalWeeks = 1;

    int totalMonths =
        (futureDate.year - today.year) * 12 + (futureDate.month - today.month);
    if (totalMonths < 1) totalMonths = 1;

    final dailyAmount = calculatedAmount / totalDays;
    final weeklyAmount = calculatedAmount / totalWeeks;
    final monthlyAmount = calculatedAmount / totalMonths;

    final highlightColor = Colors.teal;
    final textColor = isDark ? Colors.white : Colors.black;
    final texts = ref.watch(appTextsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        freqTitle(
          texts.chooseInvestmentFrequency,
          textColor,
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            dailyExpanded(
                ref, selectedFrequency, highlightColor, isDark, textColor),
            const SizedBox(width: 10),
            weeklyExpanded(
                ref, selectedFrequency, highlightColor, isDark, textColor),
            const SizedBox(width: 10),
            monthlyExpanded(
                ref, selectedFrequency, highlightColor, isDark, textColor),
          ],
        ),
        freqConditon(
            ref,
            selectedFrequency,
            highlightColor,
            isDark,
            calculatedYear,
            calculatedAmount,
            dailyAmount,
            weeklyAmount,
            monthlyAmount)
      ],
    );
  }
}
