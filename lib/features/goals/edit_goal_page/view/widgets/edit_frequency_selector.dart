import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:money_mangmnt/views.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Investment Frequency',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  ref.read(editFrequencyProvider.notifier).state = 'Daily';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedFrequency == 'Daily'
                        ? Colors.teal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFrequency == 'Daily'
                          ? Colors.teal
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
                            : isDark
                                ? Colors.white
                                : Colors.black,
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
                  ref.read(editFrequencyProvider.notifier).state = 'Weekly';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedFrequency == 'Weekly'
                        ? Colors.teal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFrequency == 'Weekly'
                          ? Colors.teal
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
                            : isDark
                                ? Colors.white
                                : Colors.black,
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
                  ref.read(editFrequencyProvider.notifier).state = 'Monthly';
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedFrequency == 'Monthly'
                        ? Colors.teal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: selectedFrequency == 'Monthly'
                          ? Colors.teal
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
                            : isDark
                                ? Colors.white
                                : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
