import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/view/goals_page.dart';
import 'package:money_mangmnt/features/goals/no_goal_page/no_goal_page.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/controller/goal_list_controller.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/model/goal_list_model.dart';

class GoalPageWrapper extends ConsumerStatefulWidget {
  const GoalPageWrapper({Key? key}) : super(key: key);

  @override
  ConsumerState<GoalPageWrapper> createState() => _GoalPageWrapperState();
}

class _GoalPageWrapperState extends ConsumerState<GoalPageWrapper> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalListStateProvider.notifier).getGoalsList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: ref.watch(isDarkProvider)
            ? AppColors.current(true).scaffoldBackground
            : AppColors.current(false).scaffoldBackground,
        appBar: GrowkAppBar(
          title: 'Your Savings Goals',
          isBackBtnNeeded: false,
        ),
        body: Container(
          color: ref.watch(isDarkProvider) ? Colors.black : Colors.white,
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      color: isDark ? Colors.white : Colors.black),
                  SizedBox(height: 16),
                  Text('Loading your goals...'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
                    Icon(
                      isKycError ? Icons.verified_user : Icons.error_outline,
                      size: 64,
                      color: isKycError
                          ? Colors.orange
                          : (isDark ? Colors.red[300] : Colors.red),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isKycError
                          ? 'KYC Verification Required'
                          : 'Failed to load goals',
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
                    if (isKycError)
                      Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Please complete KYC verification from your profile'),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Complete KYC'),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              ref
                                  .read(goalListStateProvider.notifier)
                                  .refreshGoals();
                            },
                            child: const Text('Refresh'),
                          ),
                        ],
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          ref
                              .read(goalListStateProvider.notifier)
                              .refreshGoals();
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
          ),
        ),
      ),
    );
  }

  Widget _buildContentBasedOnData(GoalListModel goalListModel) {
    if (goalListModel.data.isEmpty) {
      return const NoGoalPage();
    } else {
      return const GoalsPage();
    }
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
// import 'package:growk_v2/core/theme/app_theme.dart';
// import 'package:growk_v2/core/widgets/growk_app_bar.dart';
// import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
// import 'package:growk_v2/features/goals/goal_list_page/view/paginated_goal_page.dart';
// import 'package:growk_v2/features/no_goal_page/no_goal_page.dart';

// class GoalPageWrapper extends ConsumerStatefulWidget {
//   const GoalPageWrapper({Key? key}) : super(key: key);

//   @override
//   ConsumerState<GoalPageWrapper> createState() => _GoalPageWrapperState();
// }

// class _GoalPageWrapperState extends ConsumerState<GoalPageWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(goalListStateProvider.notifier).getGoalsList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paginatedState = ref.watch(paginatedGoalListProvider);

//     if (paginatedState.isLoading && paginatedState.goals.isEmpty) {
//       return _buildLoadingState();
//     }

//     if (paginatedState.hasError && paginatedState.goals.isEmpty) {
//       return _buildErrorState(paginatedState.errorMessage ?? 'Unknown error');
//     }

//     if (paginatedState.goals.isNotEmpty) {
//       return const PaginatedGoalsPage();
//     }

//     return const NoGoalPage();
//   }

//   Widget _buildLoadingState() {
//     return ScalingFactor(
//       child: Scaffold(
//         backgroundColor: ref.watch(isDarkProvider)
//             ? AppColors.current(true).scaffoldBackground
//             : AppColors.current(false).scaffoldBackground,
//         appBar: GrowkAppBar(
//           title: 'Your Savings Goals',
//           isBackBtnNeeded: false,
//         ),
//         body: Container(
//           color: ref.watch(isDarkProvider) ? Colors.black : Colors.white,
//           child: const SafeArea(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: Colors.teal),
//                   SizedBox(height: 16),
//                   Text('Loading your goals...'),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildErrorState(String error) {
//     final isDark = ref.watch(isDarkProvider);
//     bool isKycError = error.toLowerCase().contains('kyc');

//     return ScalingFactor(
//       child: Scaffold(
//         backgroundColor: AppColors.current(isDark).scaffoldBackground,
//         appBar: GrowkAppBar(
//           title: 'Your Savings Goals',
//           isBackBtnNeeded: false,
//         ),
//         body: Container(
//           color: isDark ? Colors.black : Colors.white,
//           child: SafeArea(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       isKycError ? Icons.verified_user : Icons.error_outline,
//                       size: 64,
//                       color: isKycError
//                           ? Colors.orange
//                           : (isDark ? Colors.red[300] : Colors.red),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       isKycError
//                           ? 'KYC Verification Required'
//                           : 'Failed to load goals',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: isDark ? Colors.white : Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       error,
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 14,
//                         color: isDark ? Colors.grey[300] : Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     if (isKycError)
//                       Column(
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                   content: Text(
//                                       'Please complete KYC verification from your profile'),
//                                   backgroundColor: Colors.orange,
//                                 ),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.orange,
//                               foregroundColor: Colors.white,
//                             ),
//                             child: const Text('Complete KYC'),
//                           ),
//                           const SizedBox(height: 8),
//                           TextButton(
//                             onPressed: () {
//                               ref
//                                   .read(paginatedGoalListProvider.notifier)
//                                   .refreshGoals();
//                             },
//                             child: const Text('Refresh'),
//                           ),
//                         ],
//                       )
//                     else
//                       ElevatedButton(
//                         onPressed: () {
//                           ref
//                               .read(paginatedGoalListProvider.notifier)
//                               .refreshGoals();
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.teal,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: const Text('Retry'),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
