import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/goals/edit_goal_page/model/edit_goal_model.dart';
import 'package:growk_v2/features/goals/edit_goal_page/repo/edit_goal_repo.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';

final editGoalRepositoryProvider = Provider<EditGoalRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return EditGoalRepository(networkService, ref);
});

final editGoalControllerProvider = Provider<EditGoalController>((ref) {
  return EditGoalController(ref);
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
});
