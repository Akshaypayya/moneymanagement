import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_saving_amnt_slider_controller.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/widgets/target_slider_amnt_data.dart';
import 'package:growk_v2/views.dart';

Widget editSavingSliderBody(
    bool isDark,
    EditSavingAmountSliderController controller,
    WidgetRef ref,
    double amountValue) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Set Your Savings Goal',
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
            '10K',
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
                  value: amountValue,
                  onChanged: (newValue) {
                    if (!controller.focusNode.hasFocus) {
                      ref.read(editAmountSliderProvider.notifier).state =
                          newValue;
                    }
                  },
                ),
              ),
            ),
          ),
          Text(
            '1M',
            style: TextStyle(
              fontSize: 13,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
      targetAmntData(
        isDark,
        controller,
      ),
    ],
  );
}
