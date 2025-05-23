import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/controller/goal_detail_controller.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_deail_progress.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_grid.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_header.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_summary.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_transaction_list.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/view/edit_goal_page.dart';

class GoalDetailPage extends ConsumerWidget {
  final String goalName;
  final String? goalIcon;

  const GoalDetailPage({
    Key? key,
    required this.goalName,
    this.goalIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final goalDetailState = ref.watch(goalDetailStateProvider(goalName));

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: GrowkAppBar(
          title: 'Goal Details',
          isBackBtnNeeded: true,
          isActionBtnNeeded: true,
          actionWidget: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (goalDetailState.value != null &&
                  goalDetailState.value!.data != null) {
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
            },
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(goalDetailStateProvider(goalName).notifier)
                  .refreshGoalDetail();
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
            SizedBox(height: 16),
            Text('Loading goal details...'),
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

    // Debug the image data
    print('GOAL DETAIL: Goal name = ${goalData.goalName}');
    print(
        'GOAL DETAIL: Goal image provided = ${goalData.goalPic != null && goalData.goalPic!.isNotEmpty}');
    if (goalData.goalPic != null && goalData.goalPic!.isNotEmpty) {
      print(
          'GOAL DETAIL: Goal image base64 length = ${goalData.goalPic!.length}');
    }
    print('GOAL DETAIL: Goal icon asset = ${goalData.iconAsset}');

    final transactions = [
      {
        'icon': 'assets/bhim.png',
        'title': 'My Dream Home',
        'description':
            'The amount is auto-debited from your account and added to your Gold savings.',
        'amount': '3,500.00',
        'date': '22 February 15:30 PM',
      },
      {
        'icon': 'assets/bank.jpg',
        'title': 'My Dream Home',
        'description':
            'The amount is auto-debited from your account and added to your Gold savings.',
        'amount': '3,500.00',
        'date': '22 February 15:30 PM',
      },
      {
        'icon': 'assets/goldbsct.png',
        'title': 'My Dream Home',
        'description':
            'The amount is auto-debited from your account and added to your Gold savings.',
        'amount': '3,500.00',
        'date': '22 February 15:30 PM',
      },
    ];

    return Column(
      children: [
        GoalHeader(
          goalName: goalData.goalName,
          goalIcon: goalIcon, // Pass the goal icon from navigation
          goalImageWidget: goalData.getIconWidget(width: 60, height: 60),
        ),
        Container(
          color: AppColors.current(isDark).scaffoldBackground,
          height: 10,
        ),
        GoalSummary(
          amount: goalData.formattedAvailableBalance,
          profit: goalData.formattedProfit,
          currentGold: '${goalData.formattedGoldBalance} gm',
          virttualAccountNbr: goalData.linkedVA,
        ),
        GoalProgress(
          progress: goalData.progressText,
          invested: goalData.formattedWalletBalance,
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
        const SizedBox(height: 30),
        Container(
          color: AppColors.current(isDark).scaffoldBackground,
          height: 10,
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        TransactionList(transactions: transactions),
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
