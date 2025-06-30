import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/views.dart';

class SavingAmountSliderController {
  final WidgetRef ref;

  SavingAmountSliderController(this.ref);

  final double minAmount = 10000.0;
  final double maxAmount = 1000000.0;
  final double defaultAmount = 100000.0;
  bool isUpdatingFromSlider = false;
  bool isUserTyping = false;
  late FocusNode focusNode;
  late TextEditingController controller;

  double sliderValueToAmount(double sliderValue) {
    return minAmount + (sliderValue * (maxAmount - minAmount));
  }

  double amountToSliderValue(double amount) {
    final clampedAmount = amount.clamp(minAmount, maxAmount);
    return (clampedAmount - minAmount) / (maxAmount - minAmount);
  }

  String formatNumber(int number) {
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

  int parseNumber(String formattedNumber) {
    final cleanedString = formattedNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedString.isEmpty) return defaultAmount.round();
    final parsedInt = int.tryParse(cleanedString);
    if (parsedInt == null) return defaultAmount.round();

    return parsedInt.clamp(minAmount.round(), maxAmount.round());
  }

  void onTextChanged(String text) {
    if (isUpdatingFromSlider) return;

    isUserTyping = true;

    final cleanedString = text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedString.isNotEmpty) {
      final parsedInt = int.tryParse(cleanedString);
      if (parsedInt != null &&
          parsedInt >= minAmount &&
          parsedInt <= maxAmount) {
        final sliderPosition = amountToSliderValue(parsedInt.toDouble());
        ref.read(amountSliderProvider.notifier).state = sliderPosition;
      }
    }
  }

  void onEditingComplete() {
    if (isUpdatingFromSlider) return;

    isUserTyping = false;

    final parsedValue = parseNumber(controller.text);
    final formattedValue = formatNumber(parsedValue);

    controller.text = formattedValue;

    final sliderPosition = amountToSliderValue(parsedValue.toDouble());
    ref.read(amountSliderProvider.notifier).state = sliderPosition;
  }

  void updateTextFieldFromSlider() {
    if (isUserTyping || focusNode.hasFocus) return;

    isUpdatingFromSlider = true;
    try {
      final currentSliderValue = ref.read(amountSliderProvider);
      final amount = sliderValueToAmount(currentSliderValue);

      final roundedAmount = amount.round();
      final formattedAmount = formatNumber(roundedAmount);

      if (controller.text != formattedAmount) {
        controller.text = formattedAmount;
      }
    } finally {
      isUpdatingFromSlider = false;
    }
  }

  double getCurrentAmount() {
    if (focusNode.hasFocus || isUserTyping) {
      return parseNumber(controller.text).toDouble();
    } else {
      return sliderValueToAmount(ref.read(amountSliderProvider));
    }
  }
}
