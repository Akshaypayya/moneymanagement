import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/provider/goal_list_pagination.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/repo/goal_list_repo.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/controller/goal_list_controller.dart';

final goalListRepositoryProvider = Provider<GoalListRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return GoalListRepository(networkService, ref);
});

final goalListStateProvider =
    StateNotifierProvider<GoalListStateNotifier, AsyncValue<GoalListModel>>(
        (ref) {
  return GoalListStateNotifier(ref);
});

final goalListPaginatedStateProvider = Provider<GoalListPaginatedState>((ref) {
  return GoalListPaginatedState(
    goals: [],
    isLoading: false,
    hasError: false,
    errorMessage: null,
    hasMoreGoals: true,
    currentPage: 0,
    itemsPerPage: 5,
  );
});

final paginatedGoalListProvider =
    StateNotifierProvider<PaginatedGoalListNotifier, GoalListPaginatedState>(
        (ref) {
  return PaginatedGoalListNotifier(ref);
});
