import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/custom_slider_wrapper.dart';

class SavingsAmountSlider extends ConsumerStatefulWidget {
  const SavingsAmountSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SavingsAmountSliderState();
}

class _SavingsAmountSliderState extends ConsumerState<SavingsAmountSlider> {
  late TextEditingController _controller;
  bool _isUpdatingFromSlider = false;
  bool _isUserTyping = false;
  late FocusNode _focusNode;

  final double minAmount = 10000.0;
  final double maxAmount = 1000000.0;
  final double defaultAmount = 100000.0;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sliderValue = _amountToSliderValue(defaultAmount);
      ref.read(amountSliderProvider.notifier).state = sliderValue;
    });

    _controller =
        TextEditingController(text: _formatNumber(defaultAmount.round()));

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && _isUserTyping) {
        _onEditingComplete();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  double _sliderValueToAmount(double sliderValue) {
    return minAmount + (sliderValue * (maxAmount - minAmount));
  }

  double _amountToSliderValue(double amount) {
    final clampedAmount = amount.clamp(minAmount, maxAmount);
    return (clampedAmount - minAmount) / (maxAmount - minAmount);
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
    if (cleanedString.isEmpty) return defaultAmount.round();
    final parsedInt = int.tryParse(cleanedString);
    if (parsedInt == null) return defaultAmount.round();

    return parsedInt.clamp(minAmount.round(), maxAmount.round());
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
        final sliderPosition = _amountToSliderValue(parsedInt.toDouble());
        ref.read(amountSliderProvider.notifier).state = sliderPosition;
      }
    }
  }

  void _onEditingComplete() {
    if (_isUpdatingFromSlider) return;

    _isUserTyping = false;

    final parsedValue = _parseNumber(_controller.text);
    final formattedValue = _formatNumber(parsedValue);

    _controller.text = formattedValue;

    final sliderPosition = _amountToSliderValue(parsedValue.toDouble());
    ref.read(amountSliderProvider.notifier).state = sliderPosition;
  }

  void _updateTextFieldFromSlider() {
    if (_isUserTyping || _focusNode.hasFocus) return;

    _isUpdatingFromSlider = true;
    try {
      final currentSliderValue = ref.read(amountSliderProvider);
      final amount = _sliderValueToAmount(currentSliderValue);

      final roundedAmount = amount.round();
      final formattedAmount = _formatNumber(roundedAmount);

      if (_controller.text != formattedAmount) {
        _controller.text = formattedAmount;
      }
    } finally {
      _isUpdatingFromSlider = false;
    }
  }

  double getCurrentAmount() {
    if (_focusNode.hasFocus || _isUserTyping) {
      return _parseNumber(_controller.text).toDouble();
    } else {
      return _sliderValueToAmount(ref.read(amountSliderProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final amountValue = ref.watch(amountSliderProvider);

    ref.listen(amountSliderProvider, (previous, current) {
      if (previous != current && !_isUserTyping && !_focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateTextFieldFromSlider();
        });
      }
    });

    final amountDisplay = Row(
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
          width: 80,
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
                    color: isDark ? Colors.grey[600]! : Colors.grey[400]!,
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(3, 10, 0, -10),
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
    );

    return CustomSliderWrapper(
      title: 'Set Your Savings Goal',
      leftLabel: '10K',
      rightLabel: '1M',
      value: amountValue,
      stateProvider: amountSliderProvider,
      valueDisplay: amountDisplay,
      isSteppedAmount: false,
    );
  }
}
