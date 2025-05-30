import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/views.dart';

class EditTargetYearSlider extends ConsumerStatefulWidget {
  const EditTargetYearSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditTargetYearSliderState();
}

class _EditTargetYearSliderState extends ConsumerState<EditTargetYearSlider> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final yearValue = ref.watch(editYearSliderProvider);
    final targetYear = 2025 + (yearValue * 25).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Your Target Year',
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
            Text(
              '2025',
              style: TextStyle(
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 8,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    overlayShape: const RoundSliderOverlayShape(
                      overlayRadius: 20,
                    ),
                    activeTrackColor: Colors.teal,
                    inactiveTrackColor:
                        isDark ? Colors.grey[800] : Colors.grey[300],
                    thumbColor: Colors.teal,
                    overlayColor: Colors.teal.withOpacity(0.3),
                  ),
                  child: Slider(
                    value: yearValue,
                    onChanged: (newValue) {
                      ref.read(editYearSliderProvider.notifier).state =
                          newValue;
                    },
                  ),
                ),
              ),
            ),
            Text(
              '2050',
              style: TextStyle(
                fontSize: 13,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Text(
              'Completion Year: $targetYear',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
