import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:money_mangmnt/views.dart';
import 'package:intl/intl.dart';

class EditSavingAmountSlider extends ConsumerStatefulWidget {
  const EditSavingAmountSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSavingSliderState();
}

class _EditSavingSliderState extends ConsumerState<EditSavingAmountSlider> {
  final TextEditingController _controller = TextEditingController();
  final NumberFormat _formatter = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTextFieldFromSlider();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateTextFieldFromSlider() {
    final amountValue = ref.read(editAmountSliderProvider);
    final targetAmount = 10000 + (amountValue * (1000000 - 10000)).round();
    _controller.text = _formatter.format(targetAmount);
  }

  void _updateSliderFromTextField(String value) {
    try {
      final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleanValue.isEmpty) return;

      final amount = int.parse(cleanValue);

      final clampedAmount = amount.clamp(10000, 1000000);

      final sliderValue = (clampedAmount - 10000) / (1000000 - 10000);

      ref.read(editAmountSliderProvider.notifier).state = sliderValue;
    } catch (e) {
      print('Error parsing amount: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final amountValue = ref.watch(editAmountSliderProvider);

    ref.listen(editAmountSliderProvider, (previous, current) {
      if (previous != current) {
        _updateTextFieldFromSlider();
      }
    });

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
                      ref.read(editAmountSliderProvider.notifier).state =
                          newValue;
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
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Target Amount: ',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                Image.asset(
                  AppImages.sarSymbol,
                  height: 13,
                  color: AppColors.current(isDark).primary,
                ),
                SizedBox(
                  width: 120,
                  child: Transform.translate(
                    offset: const Offset(0, -8),
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      onChanged: _updateSliderFromTextField,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      cursorColor: isDark ? Colors.white : Colors.black,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                      ],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(3, 10, 0, -10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
