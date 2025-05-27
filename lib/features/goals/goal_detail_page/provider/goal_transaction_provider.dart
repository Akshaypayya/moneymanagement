import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/controller/goal_transcation_controller.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_transaction_model.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/repo/goal_transaction_repo.dart';

final goalTransactionRepositoryProvider =
    Provider<GoalTransactionRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return GoalTransactionRepository(networkService, ref);
});

final goalTransactionStateProvider = StateNotifierProvider.family<
    GoalTransactionStateNotifier,
    AsyncValue<GoalTransactionModel>,
    String>((ref, goalName) {
  return GoalTransactionStateNotifier(ref, goalName);
});

final transactionDisplayStartProvider =
    StateProvider.family<int, String>((ref, goalName) => 0);
final transactionDisplayLengthProvider =
    StateProvider.family<int, String>((ref, goalName) => 10);

final hasMoreTransactionsProvider =
    StateProvider.family<bool, String>((ref, goalName) => true);

final isLoadingMoreTransactionsProvider =
    StateProvider.family<bool, String>((ref, goalName) => false);
