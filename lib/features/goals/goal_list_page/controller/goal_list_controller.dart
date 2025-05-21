// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/network/network_service.dart';
// import 'package:growk_v2/core/constants/app_url.dart';
// import 'package:growk_v2/features/goals/goal_list_page/model/goal_list_model.dart';
// import 'package:growk_v2/features/goals/goal_list_page/repo/goal_list_repo.dart';

// final goalListStateProvider =
//     StateNotifierProvider<GoalListStateNotifier, AsyncValue<GoalListModel>>(
//         (ref) {
//   return GoalListStateNotifier(ref);
// });

// final goalListRepositoryProvider = Provider<GoalListRepository>((ref) {
//   final networkService = NetworkService(
//     client: createUnsafeClient(),
//     baseUrl: AppUrl.baseUrl,
//   );
//   return GoalListRepository(networkService, ref);
// });

// class GoalListStateNotifier extends StateNotifier<AsyncValue<GoalListModel>> {
//   final Ref ref;

//   GoalListStateNotifier(this.ref) : super(const AsyncValue.loading());
//   Future<void> getGoalsList() async {
//     try {
//       state = const AsyncValue.loading();
//       final repository = ref.read(goalListRepositoryProvider);
//       final goalListModel = await repository.getGoalsList();

//       if (goalListModel.status == 'Success') {
//         state = AsyncValue.data(goalListModel);
//       } else if (goalListModel.status == 'Failed' &&
//           goalListModel.message != null &&
//           goalListModel.message!.contains('KYC')) {
//         final emptyGoalList = GoalListModel(
//           data: [],
//           status: 'Success',
//           message: goalListModel.message,
//         );
//         state = AsyncValue.data(emptyGoalList);
//       } else if (goalListModel.status == 'Failed' &&
//           goalListModel.message != null &&
//           goalListModel.message!.toLowerCase().contains('no goals found')) {
//         final emptyGoalList = GoalListModel(
//           data: [],
//           status: 'Success',
//           message: 'No goals found',
//         );
//         state = AsyncValue.data(emptyGoalList);
//       } else {
//         state = AsyncValue.error(
//           goalListModel.message ?? 'Failed to load goals',
//           StackTrace.current,
//         );
//       }
//     } catch (e, stackTrace) {
//       state = AsyncValue.error(e, stackTrace);
//     }
//   }

//   Future<void> refreshGoals() async {
//     await getGoalsList();
//   }
// }
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/model/goal_list_model.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:money_mangmnt/features/goals/goal_list_page/provider/goal_list_pagination.dart';

class GoalListStateNotifier extends StateNotifier<AsyncValue<GoalListModel>> {
  final Ref ref;

  GoalListStateNotifier(this.ref) : super(const AsyncValue.loading());

  Future<void> getGoalsList() async {
    try {
      state = const AsyncValue.loading();
      final repository = ref.read(goalListRepositoryProvider);
      final goalListModel = await repository.getGoalsList();

      if (goalListModel.status == 'Success') {
        state = AsyncValue.data(goalListModel);
      } else if (goalListModel.status == 'Failed' &&
          goalListModel.message != null &&
          goalListModel.message!.contains('KYC')) {
        final emptyGoalList = GoalListModel(
          data: [],
          status: 'Success',
          message: goalListModel.message,
        );
        state = AsyncValue.data(emptyGoalList);
      } else if (goalListModel.status == 'Failed' &&
          goalListModel.message != null &&
          goalListModel.message!.toLowerCase().contains('no goals found')) {
        final emptyGoalList = GoalListModel(
          data: [],
          status: 'Success',
          message: 'No goals found',
        );
        state = AsyncValue.data(emptyGoalList);
      } else {
        state = AsyncValue.error(
          goalListModel.message ?? 'Failed to load goals',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshGoals() async {
    await getGoalsList();
  }
}

class PaginatedGoalListNotifier extends StateNotifier<GoalListPaginatedState> {
  final Ref ref;
  final int _itemsPerPage = 5;
  List<GoalListItem> _allGoals = [];

  PaginatedGoalListNotifier(this.ref)
      : super(GoalListPaginatedState(
          goals: [],
          isLoading: true,
          hasError: false,
          hasMoreGoals: true,
          currentPage: 0,
          itemsPerPage: 5,
        )) {
    loadInitialGoals();
  }

  Future<void> loadInitialGoals() async {
    debugPrint('PAGINATION: Loading initial goals');

    state = state.copyWith(
      isLoading: true,
      hasError: false,
      currentPage: 0,
      goals: [],
    );

    try {
      final repository = ref.read(goalListRepositoryProvider);
      final goalListModel = await repository.getGoalsList();

      if (goalListModel.status == 'Success') {
        _allGoals = goalListModel.data;
        debugPrint('PAGINATION: Loaded ${_allGoals.length} total goals');

        await _loadNextPage();
      } else {
        debugPrint(
            'PAGINATION: API returned non-success status: ${goalListModel.status}');

        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: goalListModel.message ?? 'Failed to load goals',
          hasMoreGoals: false,
        );
      }
    } catch (e) {
      debugPrint('PAGINATION ERROR: $e');
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
        hasMoreGoals: false,
      );
    }
  }

  Future<void> loadMoreGoals() async {
    if (state.isLoading || !state.hasMoreGoals) {
      debugPrint(
          'PAGINATION: Skipping loadMoreGoals - already loading or no more goals');
      return;
    }

    debugPrint(
        'PAGINATION: Loading more goals - currently have ${state.goals.length}');
    state = state.copyWith(isLoading: true);
    await _loadNextPage();
  }

  Future<void> refreshGoals() async {
    debugPrint('PAGINATION: Refreshing goals');
    _allGoals = [];
    await loadInitialGoals();
  }

  Future<void> _loadNextPage() async {
    try {
      if (_allGoals.isEmpty) {
        final repository = ref.read(goalListRepositoryProvider);
        final goalListModel = await repository.getGoalsList();

        if (goalListModel.status == 'Success') {
          _allGoals = goalListModel.data;
          debugPrint('PAGINATION: Fetched ${_allGoals.length} total goals');
        } else {
          debugPrint(
              'PAGINATION: Failed to fetch goals: ${goalListModel.message}');
          state = state.copyWith(
            isLoading: false,
            hasError: true,
            errorMessage: goalListModel.message ?? 'Failed to load goals',
            hasMoreGoals: false,
          );
          return;
        }
      }

      final nextPage = state.currentPage + 1;
      final startIndex = (nextPage - 1) * _itemsPerPage;

      if (startIndex >= _allGoals.length) {
        debugPrint('PAGINATION: No more goals to load');
        state = state.copyWith(
          isLoading: false,
          hasMoreGoals: false,
        );
        return;
      }

      final endIndex = (startIndex + _itemsPerPage) > _allGoals.length
          ? _allGoals.length
          : (startIndex + _itemsPerPage);

      final paginatedGoals = _allGoals.sublist(startIndex, endIndex);
      debugPrint('PAGINATION: Loaded goals $startIndex to $endIndex');

      final hasMore = _allGoals.length > endIndex;

      final updatedGoals =
          nextPage == 1 ? paginatedGoals : [...state.goals, ...paginatedGoals];

      state = state.copyWith(
        goals: updatedGoals,
        isLoading: false,
        hasError: false,
        hasMoreGoals: hasMore,
        currentPage: nextPage,
      );

      debugPrint(
          'PAGINATION: Now showing ${updatedGoals.length} goals, hasMore: $hasMore');
    } catch (e) {
      debugPrint('PAGINATION ERROR: $e');
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
