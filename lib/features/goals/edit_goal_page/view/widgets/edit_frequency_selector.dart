import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/freq_conditn.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/widgets/edit_freq_condition.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/widgets/edit_freq_data.dart';
import 'package:growk_v2/views.dart';

class EditFrequencySelector extends ConsumerStatefulWidget {
  final double investedAmount;
  const EditFrequencySelector({super.key, required this.investedAmount});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditFrequencySelectorState();
}

class _EditFrequencySelectorState extends ConsumerState<EditFrequencySelector> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final selectedFrequency = ref.watch(editFrequencyProvider);
    final highlightColor = Colors.teal;

    final yearSliderValue = ref.watch(editYearSliderProvider);
    final amountSliderValue = ref.watch(editAmountSliderProvider);

    final DateTime today = DateTime.now();
    final targetYear = today.year + (yearSliderValue * 25).round();

    final minAmount = 10000.0;
    final maxAmount = 1000000.0;
    final targetAmount =
        minAmount + (amountSliderValue * (maxAmount - minAmount));

    final yearValue = targetYear;
    final amountValue = targetAmount;

    DateTime futureDate = DateTime(yearValue.toInt(), 12, 31);

    final investedAmount = widget.investedAmount;
    final newAmountValue = amountValue - investedAmount;

    int totalDays = futureDate.difference(today).inDays;
    if (totalDays < 1) totalDays = 1;

    int totalWeeks = (totalDays / 7).ceil();
    if (totalWeeks < 1) totalWeeks = 1;

    int totalMonths =
        (futureDate.year - today.year) * 12 + (futureDate.month - today.month);
    if (totalMonths < 1) totalMonths = 1;

    final dailyAmount = (newAmountValue / totalDays);
    final weeklyAmount = (newAmountValue / totalWeeks);
    final monthlyAmount = (newAmountValue / totalMonths);

    debugPrint('''
  EditFrequencySelector - Target Values:
  Target Year: $targetYear (from slider: $yearSliderValue)
  Target Amount: ${targetAmount.toStringAsFixed(2)} (from slider: $amountSliderValue)
  Invested Amount: $investedAmount
  New Amount Value: $newAmountValue
  
  Frequency Calculations:
  Daily: ${dailyAmount.toStringAsFixed(2)}
  Weekly: ${weeklyAmount.toStringAsFixed(2)}
  Monthly: ${monthlyAmount.toStringAsFixed(2)}
  
  Time Calculations:
  Today: $today
  Future Date: $futureDate
  Total Days: $totalDays
  Total Weeks: $totalWeeks
  Total Months: $totalMonths
  ''');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        editFreqTitle('Choose Your Investment Frequency', isDark),
        const SizedBox(height: 15),
        Row(
          children: [
            editDailyExpanded(ref, selectedFrequency, isDark),
            const SizedBox(width: 10),
            editWeeklyExpanded(ref, selectedFrequency, isDark),
            const SizedBox(width: 10),
            editMonthlyExpanded(ref, selectedFrequency, isDark),
          ],
        ),
        editFreqConditon(
          ref,
          selectedFrequency,
          highlightColor,
          isDark,
          yearValue.toInt(),
          amountValue,
          dailyAmount,
          weeklyAmount,
          monthlyAmount,
        )
      ],
    );
  }
}
