import 'dart:io';

import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/widget/edit_auto_deposit.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/widgets/edit_frequency_selector.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/widgets/edit_goal_icon_picker.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/widgets/edit_saving_slider.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/widgets/edit_target_slider.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/widgets/goal_name_widget.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/widgets/update_goal_btn.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:money_mangmnt/views.dart';

class EditGoalPage extends ConsumerStatefulWidget {
  final GoalData? goalData;

  const EditGoalPage({
    Key? key,
    this.goalData,
  }) : super(key: key);

  @override
  ConsumerState<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends ConsumerState<EditGoalPage> {
  late TextEditingController _goalNameController;

  @override
  void initState() {
    super.initState();
    _goalNameController =
        TextEditingController(text: widget.goalData?.goalName);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(editGoalControllerProvider)
          .initializeWithGoalData(widget.goalData!);
      ref.read(editGoalNameProvider.notifier).state = widget.goalData!.goalName;
    });
  }

  @override
  void dispose() {
    _goalNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(editGoalControllerProvider);

    final selectedIcon = ref.watch(editSelectedGoalIconProvider);
    final selectedImage = ref.watch(editSelectedImageFileProvider);
    final yearValue = ref.watch(editYearSliderProvider);
    final amountValue = ref.watch(editAmountSliderProvider);
    final selectedFrequency = ref.watch(editFrequencyProvider);
    final autoDeposit = ref.watch(editAutoDepositProvider);

    final targetYear = 2025 + (yearValue * 25).round();
    final targetAmount = 10000 + (amountValue * (10000000 - 10000)).round();
    final double sliderSectionWidth = MediaQuery.of(context).size.width - 40;
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: GrowkAppBar(title: 'Edit Goal', isBackBtnNeeded: true),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 30,
                children: [
                  EditGoalIconPicker(
                    goalData: widget.goalData,
                  ),
                  GoalNameWidget(
                    goalName: widget.goalData?.goalName ?? 'Goal Name',
                  ),
                  SizedBox(
                    width: sliderSectionWidth,
                    child: EditTargetYearSlider(),
                  ),
                  SizedBox(
                    width: sliderSectionWidth,
                    child: EditSavingAmountSlider(),
                  ),
                  EditFrequencySelector(),
                  EditAutoDeposit(),
                  UpdateGoalButton(
                    goalData: widget.goalData,
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
