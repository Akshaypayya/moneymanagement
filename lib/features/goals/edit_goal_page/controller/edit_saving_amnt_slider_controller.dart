import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/views.dart';

class EditSavingAmountSliderController {
  final WidgetRef ref;

  EditSavingAmountSliderController(this.ref);

  late TextEditingController controller;
  bool isUpdatingFromSlider = false;
  bool isUserTyping = false;
  late FocusNode focusNode;

  final double minAmount = 10000.0;
  final double maxAmount = 1000000.0;

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
    if (cleanedString.isEmpty) return minAmount.round();

    final parsedInt = int.tryParse(cleanedString);
    if (parsedInt == null) return minAmount.round();

    return parsedInt.clamp(minAmount.round(), maxAmount.round());
  }

  void updateTextFieldFromSlider() {
    if (isUserTyping || focusNode.hasFocus) return;

    isUpdatingFromSlider = true;
    try {
      final amountValue = ref.read(editAmountSliderProvider);
      final targetAmount = minAmount + (amountValue * (maxAmount - minAmount));
      final roundedAmount = targetAmount.round();

      final formattedAmount = formatNumber(roundedAmount);

      if (controller.text != formattedAmount) {
        controller.text = formattedAmount;
      }
    } finally {
      isUpdatingFromSlider = false;
    }
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
        final sliderPosition =
            (parsedInt - minAmount) / (maxAmount - minAmount);
        ref.read(editAmountSliderProvider.notifier).state =
            sliderPosition.clamp(0.0, 1.0);
      }
    }
  }

  void onEditingComplete() {
    if (isUpdatingFromSlider) return;

    isUserTyping = false;

    final parsedValue = parseNumber(controller.text);
    final formattedValue = formatNumber(parsedValue);

    controller.text = formattedValue;

    final sliderPosition = (parsedValue - minAmount) / (maxAmount - minAmount);
    ref.read(editAmountSliderProvider.notifier).state =
        sliderPosition.clamp(0.0, 1.0);
  }
}
