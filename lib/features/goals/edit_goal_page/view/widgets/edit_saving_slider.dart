import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:money_mangmnt/views.dart';

class EditSavingAmountSlider extends ConsumerStatefulWidget {
  const EditSavingAmountSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSavingAmountSliderState();
}

class _EditSavingAmountSliderState
    extends ConsumerState<EditSavingAmountSlider> {
  late TextEditingController _controller;
  bool _isUpdatingFromSlider = false;
  bool _isUserTyping = false;
  late FocusNode _focusNode;

  final double minAmount = 10000.0;
  final double maxAmount = 1000000.0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _controller = TextEditingController();

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isUserTyping) {
        _onEditingComplete();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateTextFieldFromSlider();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    final String numStr = number.toString();
    final StringBuffer result = StringBuffer();
    int count = 0;

    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result.write(numStr[i]);
      if (count % 3 == 0 && i > 0) {
        result.write(',');
      }
    }

    return result.toString().split('').reversed.join('');
  }

  int _parseNumber(String formattedNumber) {
    final cleanedString = formattedNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedString.isEmpty) return minAmount.round();

    final parsedInt = int.tryParse(cleanedString);
    if (parsedInt == null) return minAmount.round();

    return parsedInt.clamp(minAmount.round(), maxAmount.round());
  }

  void _updateTextFieldFromSlider() {
    if (_isUserTyping || _focusNode.hasFocus) return;

    _isUpdatingFromSlider = true;
    try {
      final amountValue = ref.read(editAmountSliderProvider);
      final targetAmount = minAmount + (amountValue * (maxAmount - minAmount));
      final roundedAmount = targetAmount.round();

      final formattedAmount = _formatNumber(roundedAmount);

      if (_controller.text != formattedAmount) {
        _controller.text = formattedAmount;
      }
    } finally {
      _isUpdatingFromSlider = false;
    }
  }

  void _onTextChanged(String text) {
    if (_isUpdatingFromSlider) return;

    _isUserTyping = true;

    final cleanedString = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedString.isNotEmpty) {
      final parsedInt = int.tryParse(cleanedString);
      if (parsedInt != null &&
          parsedInt >= minAmount &&
          parsedInt <= maxAmount) {
        final sliderPosition =
            (parsedInt - minAmount) / (maxAmount - minAmount);
        ref.read(editAmountSliderProvider.notifier).state =
            sliderPosition.clamp(0.0, 1.0);
      }
    }
  }

  void _onEditingComplete() {
    if (_isUpdatingFromSlider) return;

    _isUserTyping = false;

    final parsedValue = _parseNumber(_controller.text);
    final formattedValue = _formatNumber(parsedValue);

    _controller.text = formattedValue;

    final sliderPosition = (parsedValue - minAmount) / (maxAmount - minAmount);
    ref.read(editAmountSliderProvider.notifier).state =
        sliderPosition.clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final amountValue = ref.watch(editAmountSliderProvider);

    ref.listen(editAmountSliderProvider, (previous, current) {
      if (previous != current && !_isUserTyping && !_focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateTextFieldFromSlider();
        });
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
                      if (!_focusNode.hasFocus) {
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
                const SizedBox(width: 5),
                SizedBox(
                  width: 70,
                  child: Transform.translate(
                    offset: const Offset(0, -8),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      onChanged: _onTextChanged,
                      onSubmitted: (_) => _onEditingComplete(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      cursorColor: isDark ? Colors.white : Colors.black,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                        LengthLimitingTextInputFormatter(15),
                      ],
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color:
                                isDark ? Colors.grey[600]! : Colors.grey[400]!,
                          ),
                        ),
                        contentPadding:
                            const EdgeInsets.fromLTRB(3, 10, 0, -10),
                        hintText: '10K - 1M',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                        ),
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
