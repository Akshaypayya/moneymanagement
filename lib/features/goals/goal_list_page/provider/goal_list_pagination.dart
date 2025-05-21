import 'package:money_mangmnt/features/goals/goal_list_page/model/goal_list_model.dart';

class GoalListPaginatedState {
  final List<GoalListItem> goals;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool hasMoreGoals;
  final int currentPage;
  final int itemsPerPage;

  GoalListPaginatedState({
    required this.goals,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    required this.hasMoreGoals,
    required this.currentPage,
    required this.itemsPerPage,
  });

  GoalListPaginatedState copyWith({
    List<GoalListItem>? goals,
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? hasMoreGoals,
    int? currentPage,
    int? itemsPerPage,
  }) {
    return GoalListPaginatedState(
      goals: goals ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      hasMoreGoals: hasMoreGoals ?? this.hasMoreGoals,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
    );
  }
}
