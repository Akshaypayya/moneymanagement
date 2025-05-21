import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/add_goal_page.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/view/widgets/goal_item.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/widget/goals_header.dart';

class PaginatedGoalsPage extends ConsumerStatefulWidget {
  const PaginatedGoalsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PaginatedGoalsPage> createState() => _PaginatedGoalsPageState();
}

class _PaginatedGoalsPageState extends ConsumerState<PaginatedGoalsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final state = ref.read(paginatedGoalListProvider);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoading &&
        state.hasMoreGoals) {
      print("PAGINATION: Reached near bottom, loading more goals...");
      ref.read(paginatedGoalListProvider.notifier).loadMoreGoals();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final goalListState = ref.watch(paginatedGoalListProvider);

    print(
        "PAGINATION: Current state - ${goalListState.goals.length} goals loaded, "
        "isLoading: ${goalListState.isLoading}, "
        "hasMore: ${goalListState.hasMoreGoals}, "
        "page: ${goalListState.currentPage}");

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
              ref.read(paginatedGoalListProvider.notifier).refreshGoals();
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
                await ref
                    .read(paginatedGoalListProvider.notifier)
                    .refreshGoals();
              },
              child: Column(
                children: [
                  Column(
                    children: [
                      const GoalsHeader(),
                      Container(
                        color: AppColors.current(isDark).scaffoldBackground,
                        height: 10,
                      ),
                    ],
                  ),
                  Expanded(
                    child: goalListState.goals.isEmpty &&
                            !goalListState.isLoading
                        ? _buildEmptyState(isDark)
                        : ListView.builder(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: goalListState.goals.length + 1,
                            itemBuilder: (context, index) {
                              if (index == goalListState.goals.length) {
                                return _buildFooter(goalListState, isDark);
                              }

                              final goal = goalListState.goals[index];
                              return GoalItem(
                                iconAsset: goal.iconAsset,
                                iconWidget:
                                    goal.getIconWidget(width: 35, height: 35),
                                title: goal.goalName,
                                amount: goal.formattedAvailableBalance,
                                profit: goal.formattedProfit,
                                currentGold: '${goal.formattedGoldBalance} gm',
                                invested: goal.formattedWalletBalance,
                                target: goal.formattedTargetAmount,
                                progress: goal.progressText,
                                progressPercent: goal.progressPercent,
                                isLast: false,
                              );
                            },
                          ),
                  ),
                  if (goalListState.hasError && goalListState.goals.isEmpty)
                    _buildErrorOverlay(goalListState, isDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(goalListState, bool isDark) {
    if (goalListState.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
          ),
        ),
      );
    } else if (goalListState.hasMoreGoals) {
      return const SizedBox(height: 80);
    } else if (goalListState.goals.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Text(
            'You\'ve reached the end of your goals',
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/no_goals.png',
              width: 150,
              height: 150,
              errorBuilder: (_, __, ___) => Icon(
                Icons.savings_outlined,
                size: 100,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No goals found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Create your first savings goal by tapping the + button',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(goalListState, bool isDark) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline,
                size: 50,
                color: isDark ? Colors.red[300] : Colors.red,
              ),
              const SizedBox(height: 10),
              Text(
                'Error loading goals',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                goalListState.errorMessage ?? 'An unknown error occurred',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  ref.read(paginatedGoalListProvider.notifier).refreshGoals();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
