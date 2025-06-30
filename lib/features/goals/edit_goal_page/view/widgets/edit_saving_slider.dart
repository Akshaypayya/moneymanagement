import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_saving_amnt_slider_controller.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/widgets/body_edit_savng_slidr.dart';
import 'package:growk_v2/views.dart';

class EditSavingAmountSlider extends ConsumerStatefulWidget {
  const EditSavingAmountSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditSavingAmountSliderState();
}

class _EditSavingAmountSliderState
    extends ConsumerState<EditSavingAmountSlider> {
  late EditSavingAmountSliderController controller;

  @override
  void initState() {
    super.initState();
    controller = EditSavingAmountSliderController(ref);
    controller.focusNode = FocusNode();
    controller.controller = TextEditingController();

    controller.focusNode.addListener(() {
      if (!controller.focusNode.hasFocus && controller.isUserTyping) {
        controller.onEditingComplete();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.updateTextFieldFromSlider();
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
    final amountValue = ref.watch(editAmountSliderProvider);

    ref.listen(editAmountSliderProvider, (previous, current) {
      if (previous != current &&
          !controller.isUserTyping &&
          !controller.focusNode.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.updateTextFieldFromSlider();
        });
      }
    });

    return editSavingSliderBody(
      isDark,
      controller,
      ref,
      amountValue,
    );
  }
}
