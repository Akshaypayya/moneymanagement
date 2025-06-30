import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/features/goals/add_goal_page/controller/saving_slider_controller.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/amntDisp_row.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/custom_slider_wrapper.dart';

class SavingsAmountSlider extends ConsumerStatefulWidget {
  const SavingsAmountSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SavingsAmountSliderState();
}

class _SavingsAmountSliderState extends ConsumerState<SavingsAmountSlider> {
  late SavingAmountSliderController controller;

  @override
  void initState() {
    super.initState();
    controller = SavingAmountSliderController(ref);

    controller.focusNode = FocusNode();
    controller.controller = TextEditingController(
      text: controller.formatNumber(controller.defaultAmount.round()),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sliderValue =
          controller.amountToSliderValue(controller.defaultAmount);
      ref.read(amountSliderProvider.notifier).state = sliderValue;
    });

    controller.focusNode.addListener(() {
      if (!controller.focusNode.hasFocus && controller.isUserTyping) {
        controller.onEditingComplete();
      }
    });
  }

  @override
  void dispose() {
    controller.focusNode.dispose();
    controller.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final amountValue = ref.watch(amountSliderProvider);

    ref.listen(amountSliderProvider, (previous, current) {
      if (previous != current &&
          !controller.isUserTyping &&
          !controller.focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.updateTextFieldFromSlider();
        });
      }
    });

    final amountDisplay = amntDispRow(
      isDark,
      controller,
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
