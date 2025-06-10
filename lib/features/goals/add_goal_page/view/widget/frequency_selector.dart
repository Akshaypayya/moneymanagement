import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';

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
        Text(
          'Choose Your Investment Frequency',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: textColor,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(frequencyProvider.notifier).state = 'Daily';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedFrequency == 'Daily'
                        ? highlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFrequency == 'Daily'
                          ? highlightColor
                          : isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Daily',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: selectedFrequency == 'Daily'
                            ? Colors.white
                            : textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(frequencyProvider.notifier).state = 'Weekly';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedFrequency == 'Weekly'
                        ? highlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFrequency == 'Weekly'
                          ? highlightColor
                          : isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Weekly',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: selectedFrequency == 'Weekly'
                            ? Colors.white
                            : textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(frequencyProvider.notifier).state = 'Monthly';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedFrequency == 'Monthly'
                        ? highlightColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFrequency == 'Monthly'
                          ? highlightColor
                          : isDark
                              ? Colors.grey[700]!
                              : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Monthly',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: selectedFrequency == 'Monthly'
                            ? Colors.white
                            : textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.sarSymbol,
                      height: 12,
                      color: selectedFrequency == 'Daily'
                          ? highlightColor
                          : isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                    ),
                    Text(
                      ' ${dailyAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: selectedFrequency == 'Daily'
                            ? highlightColor
                            : isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.sarSymbol,
                      height: 12,
                      color: selectedFrequency == 'Weekly'
                          ? highlightColor
                          : isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                    ),
                    Text(
                      ' ${weeklyAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: selectedFrequency == 'Weekly'
                            ? highlightColor
                            : isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppImages.sarSymbol,
                      height: 12,
                      color: selectedFrequency == 'Monthly'
                          ? highlightColor
                          : isDark
                              ? Colors.grey[400]
                              : Colors.grey[600],
                    ),
                    Text(
                      ' ${monthlyAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: selectedFrequency == 'Monthly'
                            ? highlightColor
                            : isDark
                                ? Colors.grey[400]
                                : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
