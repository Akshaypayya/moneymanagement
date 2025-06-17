import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/frequency_selector.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/goal_icon_picker.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/goal_name_input.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/saving_amount_slider.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/target_year_slider.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/auto_deposit_option.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/action_button.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';

class CreateGoalPage extends ConsumerStatefulWidget {
  final bool resetOnInit;

  const CreateGoalPage({
    Key? key,
    this.resetOnInit = true,
  }) : super(key: key);

  @override
  ConsumerState<CreateGoalPage> createState() => _CreateGoalPageState();
}

class _CreateGoalPageState extends ConsumerState<CreateGoalPage> {
  @override
  void initState() {
    super.initState();
    if (widget.resetOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(createGoalControllerProvider).resetFormState();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(createGoalControllerProvider);
    final double sliderSectionWidth = MediaQuery.of(context).size.width - 40;
    return ScalingFactor(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: GrowkAppBar(title: 'Create Goal', isBackBtnNeeded: true),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 30,
                    children: [
                      const GoalIconPicker(),
                      const GoalNameInput(),
                      // const TargetYearSlider(),
                      // const SavingsAmountSlider(),
                      SizedBox(
                        width: sliderSectionWidth,
                        child: const TargetYearSlider(),
                      ),
                      SizedBox(
                        width: sliderSectionWidth,
                        child: const SavingsAmountSlider(),
                      ),
                      const FrequencySelector(),
                      const AutoDepositOption(),
                      ActionButton(
                        label: 'Let\'s start planning',
                        onPressed: () => controller.createGoal(context, ref),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
