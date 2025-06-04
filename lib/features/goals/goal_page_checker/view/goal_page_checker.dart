import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/features/goals/goal_list_page/view/goals_page.dart';
import 'package:growk_v2/features/goals/no_goal_page/no_goal_page.dart';
import 'package:growk_v2/features/goals/goal_list_page/model/goal_list_model.dart';

final goalsRefreshTriggerProvider = StateProvider<int>((ref) => 0);

class GoalPageWrapper extends ConsumerStatefulWidget {
  const GoalPageWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalPageWrapper> createState() => _GoalPageWrapperState();
}

class _GoalPageWrapperState extends ConsumerState<GoalPageWrapper>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(goalListStateProvider.notifier).getGoalsList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.watch(goalListStateProvider.notifier).refreshGoals();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(goalsRefreshTriggerProvider, (previous, current) {
      if (previous != current) {
        ref.watch(goalListStateProvider.notifier).refreshGoals();
      }
    });

    final goalListState = ref.watch(goalListStateProvider);

    return goalListState.when(
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(error.toString()),
      data: (goalListModel) => _buildContentBasedOnData(goalListModel),
    );
  }

  Widget _buildLoadingState() {
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        appBar: GrowkAppBar(
          title: 'Your Savings Goals',
          isBackBtnNeeded: false,
        ),
        body: Container(
          color: isDark ? Colors.black : Colors.white,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: isDark ? Colors.white : Colors.black),
                  // SizedBox(height: 16),
                  // Text('Loading your goals...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildErrorState(String error) {
  //   final isDark = ref.watch(isDarkProvider);
  //   bool isKycError = error.toLowerCase().contains('kyc');

  //   return ScalingFactor(
  //     child: Scaffold(
  //       backgroundColor: AppColors.current(isDark).scaffoldBackground,
  //       appBar: GrowkAppBar(
  //         title: 'Your Savings Goals',
  //         isBackBtnNeeded: false,
  //       ),
  //       body: Container(
  //         color: isDark ? Colors.black : Colors.white,
  //         child: SafeArea(
  //           child: Center(
  //             child: Padding(
  //               padding: const EdgeInsets.all(20),
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     isKycError ? Icons.verified_user : Icons.error_outline,
  //                     size: 64,
  //                     color: isKycError
  //                         ? Colors.orange
  //                         : (isDark ? Colors.red[300] : Colors.red),
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Text(
  //                     isKycError
  //                         ? 'KYC Verification Required'
  //                         : 'Failed to load goals',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: isDark ? Colors.white : Colors.black,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     error,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: isDark ? Colors.grey[300] : Colors.grey[600],
  //                     ),
  //                   ),

  Widget _buildErrorState(String error) {
    final isDark = ref.watch(isDarkProvider);
    bool isKycError = error.toLowerCase().contains('kyc');

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        appBar: GrowkAppBar(
          title: 'Your Savings Goals',
          isBackBtnNeeded: false,
        ),
        body: Container(
          color: isDark ? Colors.black : Colors.white,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/nogoal.png',
                      height: 250,
                      width: 250,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.receipt_long_outlined,
                          size: 120,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        );
                      },
                    ),
                    ReusableText(
                      text: 'Something went wrong',
                      style: AppTextStyle(
                              textColor: AppColors.current(isDark).text)
                          .titleLrg,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      error,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.grey[300] : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (isKycError)
                      Column(
                        children: [
                          GrowkButton(
                            title: 'Complete KYC',
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please complete KYC verification from your profile'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8),
                          GrowkButton(
                            title: 'Refresh',
                            onTap: () {
                              ref
                                  .watch(goalListStateProvider.notifier)
                                  .refreshGoals();
                            },
                          )
                        ],
                      )
                    else
                      GrowkButton(
                        title: 'Retry',
                        onTap: () {
                          ref
                              .watch(goalListStateProvider.notifier)
                              .refreshGoals();
                        },
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnData(GoalListModel goalListModel) {
    if (goalListModel.data.isEmpty) {
      return NoGoalPage(
        onGoalCreated: () {
          ref.watch(goalListStateProvider.notifier).refreshGoals();
        },
      );
    } else {
      return const GoalsPage();
    }
  }
}
