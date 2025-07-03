import 'package:growk_v2/features/goals/add_goal_page/view/widget/freq_conditn.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/widgets/edit_freq_data.dart';
import 'package:growk_v2/views.dart';

class EditFrequencySelector extends ConsumerStatefulWidget {
  const EditFrequencySelector({super.key});

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
    final yearValue = ref.watch(editYearSliderProvider);
    final amountValue = ref.watch(editAmountSliderProvider);
    final autoDeposit = ref.watch(editAutoDepositProvider);

    final targetYear = 2025 + (yearValue * 25).round();
    final targetAmount = 10000 + (amountValue * (10000000 - 10000)).round();

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
        // freqConditon(
        //     ref,
        //     selectedFrequency,
        //     highlightColor,
        //     isDark,
        //     targetYear,
        //     targetAmount as double,
        //     autoDeposit as double,
        //     yearValue,
        //     amountValue)
      ],
    );
  }
}
