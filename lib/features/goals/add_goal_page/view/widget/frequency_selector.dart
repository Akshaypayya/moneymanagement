import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
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

    final duration = (calculatedYear - 2025) * 12;

    final dailyAmount = calculatedAmount / (duration * 30);
    final weeklyAmount = calculatedAmount / (duration * 4);
    final monthlyAmount = calculatedAmount / duration;

    final highlightColor = Colors.teal;
    final textColor = isDark ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        freqTitle(
          'Choose Your Investment Frequency',
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
