import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_detail_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goals_funds_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/goal_transaction_provider.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_deail_progress.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_detail_grid.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_detail_header.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_detail_summary.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_detail_transaction_list.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/edit_goal_page.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_load_amnt_botm_sheet.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_transaction.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/sell_gold_bottomsheet.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/standing_intructions.dart';

class GoalDetailPage extends ConsumerWidget {
  final String goalName;
  final String? goalIcon;
  final String goalStatus;

  const GoalDetailPage({
    Key? key,
    required this.goalName,
    this.goalIcon,
    required this.goalStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final goalDetailState = ref.watch(goalDetailStateProvider(goalName));

    final popupMenuActions = [
      PopupMenuAction(
        title: 'Edit Goal',
        subtitle: 'Modify goal details and settings',
        icon: Icons.edit,
        onTap: () => _handleEditGoal(context, ref, goalDetailState),
      ),
      PopupMenuAction(
        title: 'Load Funds',
        subtitle: 'Transfer money to this goal',
        icon: Icons.wallet,
        onTap: () => _handleLoadFunds(context, ref),
      ),
      PopupMenuAction(
        title: 'Sell Gold',
        subtitle: 'Terminate goal and transfer to wallet',
        icon: Icons.sell,
        iconColor: Colors.orange,
        onTap: () => _handleSellGold(context, ref),
      ),
    ];

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: GrowkAppBar(
          title: 'Goal Details',
          isBackBtnNeeded: true,
          showPopupMenu: goalStatus == "COMPLETED" ? false : true,
          popupMenuActions: popupMenuActions,
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(goalDetailStateProvider(goalName).notifier)
                  .refreshGoalDetail();
              await ref
                  .read(goalTransactionStateProvider(goalName).notifier)
                  .refreshTransactions();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: goalDetailState.when(
                loading: () => _buildLoadingState(ref: ref, context: context),
                error: (error, stackTrace) =>
                    _buildErrorState(error.toString(), isDark, ref),
                data: (goalViewModel) =>
                    _buildGoalDetailContent(goalViewModel, isDark, context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleEditGoal(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<GoalViewModel> goalDetailState,
  ) {
    if (goalDetailState.value != null && goalDetailState.value!.data != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditGoalPage(
            goalData: goalDetailState.value!.data!,
          ),
        ),
      ).then((_) {
        ref
            .read(goalDetailStateProvider(goalName).notifier)
            .refreshGoalDetail();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Goal data not available'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleLoadFunds(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => LoadFundsBottomSheet(
        goalName: goalName,
        onSuccess: () {
          ref
              .read(goalDetailStateProvider(goalName).notifier)
              .refreshGoalDetail();
          ref
              .read(goalTransactionStateProvider(goalName).notifier)
              .refreshTransactions();
        },
      ),
    );
  }

  void _handleSellGold(BuildContext context, WidgetRef ref) async {
    final responseMessage = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SellGoldBottomSheet(
        goalName: goalName,
        onConfirm: () {
          ref
              .read(goalDetailStateProvider(goalName).notifier)
              .refreshGoalDetail();
          ref
              .read(goalTransactionStateProvider(goalName).notifier)
              .refreshTransactions();
        },
      ),
    );

    if (responseMessage != null &&
        responseMessage.isNotEmpty &&
        context.mounted) {
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: responseMessage,
        type: SnackType.success,
      );
    }
  }

  Widget _buildLoadingState(
      {required WidgetRef ref, required BuildContext context}) {
    final isDark = ref.watch(isDarkProvider);
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(
                color: isDark ? Colors.white : Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark, WidgetRef ref) {
    return Container(
      height: 600,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: isDark ? Colors.red[300] : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load goal details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(goalDetailStateProvider(goalName).notifier)
                  .refreshGoalDetail();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalDetailContent(
      GoalViewModel goalViewModel, bool isDark, BuildContext context) {
    if (goalViewModel.data == null) {
      return _buildEmptyState(isDark);
    }

    final goalData = goalViewModel.data!;

    print('GOAL DETAIL: Goal name = ${goalData.goalName}');
    print(
        'GOAL DETAIL: Goal image provided = ${goalData.goalPic != null && goalData.goalPic!.isNotEmpty}');
    if (goalData.goalPic != null && goalData.goalPic!.isNotEmpty) {
      print(
          'GOAL DETAIL: Goal image base64 length = ${goalData.goalPic!.length}');
    }
    print('GOAL DETAIL: Goal icon asset = ${goalData.iconAsset}');

    return Column(
      children: [
        GoalHeader(
          goalName: goalData.goalName,
          goalIcon: goalIcon,
          goalImageWidget: goalData.getIconWidget(width: 60, height: 60),
          goalStatus: goalStatus,
        ),
        Container(
          color: AppColors.current(isDark).scaffoldBackground,
          height: 10,
        ),
        GoalSummary(
            amount: goalData.formattedAvailableBalance,
            profit: goalData.formattedProfit,
            currentGold: '${goalData.formattedGoldBalance} gm',
            currentGoldPrice: goalData.currentPrice.toString(),
            virtualAccountNbr: goalData.linkedVA,
            invested: goalData.investedAmount.toString()),
        GoalProgress(
          progress: goalData.progressText,
          invested: goalData.investedAmount.toString(),
          target: goalData.formattedTargetAmount,
          progressPercent: goalData.progressPercent,
        ),
        const SizedBox(height: 20),
        GoalDetailsGrid(
          targetYear: goalData.targetYear.toString(),
          targetAmount: goalData.formattedTargetAmount,
          investmentAmount: goalData.transactionAmount.toString(),
          investmentFrequency: _getFrequencyText(goalData.debitDate),
        ),
        const SizedBox(height: 20),
        Container(
          color: AppColors.current(isDark).scaffoldBackground,
          height: 10,
        ),
        StandingInstructions(
          bankId: 'Arab National Bank',
          iBanAcntNbr: goalData.linkedVA,
          acntName: 'Nexus Global Limited',
          emiAmnt: goalData.transactionAmount.toString(),
          duration: _getFrequencyText(goalData.debitDate),
          goalName: goalData.goalName,
        ),
        Container(
          color: AppColors.current(isDark).scaffoldBackground,
          height: 10,
        ),
        GoalTransactionListWidget(goalName: goalName),
        GapSpace.height20
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      height: 600,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.savings_outlined,
            size: 64,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'Goal Not Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The requested goal could not be found.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getFrequencyText(int debitDate) {
    if (debitDate == 1) {
      return 'Daily';
    } else if (debitDate == 7) {
      return 'Weekly';
    } else {
      return 'Monthly';
    }
  }
}
