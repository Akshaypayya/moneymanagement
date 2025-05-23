import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_item.dart';

class GoalDetailsGrid extends ConsumerWidget {
  final String targetYear;
  final String targetAmount;
  final String investmentAmount;
  final String investmentFrequency;

  const GoalDetailsGrid({
    Key? key,
    required this.targetYear,
    required this.targetAmount,
    required this.investmentAmount,
    required this.investmentFrequency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: DetailItem(
                  label: 'Target Year',
                  value: targetYear,
                  showSymbol: false,
                ),
              ),
              Expanded(
                child: DetailItem(
                  label: 'Target Amount',
                  value: targetAmount,
                  showSymbol: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DetailItem(
                  // label: 'Flexible Investment Amount',
                  label: 'Transaction Amount',
                  value: investmentAmount,
                  showSymbol: true,
                ),
              ),
              Expanded(
                child: DetailItem(
                  label: 'Investment Frequency',
                  value: investmentFrequency,
                  showSymbol: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
