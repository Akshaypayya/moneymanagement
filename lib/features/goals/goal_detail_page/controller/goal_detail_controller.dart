import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/repo/goal_detail_repo.dart';

final goalDetailStateProvider = StateNotifierProvider.family<
    GoalDetailStateNotifier,
    AsyncValue<GoalViewModel>,
    String>((ref, goalName) {
  return GoalDetailStateNotifier(ref, goalName);
});

final goalDetailRepositoryProvider = Provider<GoalDetailRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return GoalDetailRepository(networkService, ref);
});

class GoalDetailStateNotifier extends StateNotifier<AsyncValue<GoalViewModel>> {
  final Ref ref;
  final String goalName;

  GoalDetailStateNotifier(this.ref, this.goalName)
      : super(const AsyncValue.loading()) {
    getGoalDetail();
  }

  Future<void> getGoalDetail() async {
    try {
      state = const AsyncValue.loading();

      final repository = ref.read(goalDetailRepositoryProvider);
      final goalViewModel = await repository.getGoalDetail(goalName);

      if (goalViewModel.isSuccess && goalViewModel.data != null) {
        state = AsyncValue.data(goalViewModel);
      } else {
        state = AsyncValue.error(
          goalViewModel.status == 'failed'
              ? 'Failed to load goal details'
              : goalViewModel.status,
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refreshGoalDetail() async {
    await getGoalDetail();
  }
}
