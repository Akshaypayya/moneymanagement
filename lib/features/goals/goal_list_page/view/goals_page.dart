import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/add_goal_page.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/controller/goal_list_controller.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/view/widgets/goal_item.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/widget/goals_header.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final goalListState = ref.watch(goalListStateProvider);

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        appBar: GrowkAppBar(
          title: 'Your Savings Goals',
          isBackBtnNeeded: false,
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateGoalPage()),
            );
            if (context.mounted) {
              ref.read(goalListStateProvider.notifier).refreshGoals();
            }
          },
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        body: Container(
          color: isDark ? Colors.black : Colors.white,
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await ref.read(goalListStateProvider.notifier).refreshGoals();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GoalsHeader(),
                    Container(
                      color: AppColors.current(isDark).scaffoldBackground,
                      height: 10,
                    ),
                    _buildGoalsContent(goalListState, isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsContent(
      AsyncValue<GoalListModel> goalListState, bool isDark) {
    return goalListState.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (goalListModel) => _buildGoalsData(goalListModel, isDark),
    );
  }

  Widget _buildGoalsData(GoalListModel goalListModel, bool isDark) {
    return Column(
      children: goalListModel.data.asMap().entries.map((entry) {
        final index = entry.key;
        final goal = entry.value;
        final isLast = index == goalListModel.data.length - 1;
        debugPrint('Virtual ID :${goal.goalName} : ${goal.linkedVA}');

        return GoalItem(
          iconAsset: goal.goalPic,
          iconWidget: goal.getIconWidget(width: 35, height: 35),
          title: goal.goalName,
          amount: goal.formattedAvailableBalance,
          profit: goal.formattedProfit,
          currentGold: '${goal.formattedGoldBalance} gm',
          invested: goal.formattedWalletBalance,
          target: goal.formattedTargetAmount,
          progress: goal.progressText,
          progressPercent: goal.progressPercent,
          isLast: isLast,
        );
      }).toList(),
    );
  }
}
