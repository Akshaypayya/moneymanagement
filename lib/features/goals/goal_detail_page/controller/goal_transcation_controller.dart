import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_transaction_model.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/goal_transaction_provider.dart';

class GoalTransactionStateNotifier
    extends StateNotifier<AsyncValue<GoalTransactionModel>> {
  final Ref ref;
  final String goalName;
  List<TransactionItem> _allTransactions = [];

  GoalTransactionStateNotifier(this.ref, this.goalName)
      : super(const AsyncValue.loading()) {
    getGoalTransactions();
  }

  Future<void> getGoalTransactions({bool loadMore = false}) async {
    try {
      if (!loadMore) {
        state = const AsyncValue.loading();
        _allTransactions.clear();
        ref.read(transactionDisplayStartProvider(goalName).notifier).state = 0;
      } else {
        ref.read(isLoadingMoreTransactionsProvider(goalName).notifier).state =
            true;
      }

      final repository = ref.read(goalTransactionRepositoryProvider);
      final displayStart = ref.read(transactionDisplayStartProvider(goalName));
      final displayLength =
          ref.read(transactionDisplayLengthProvider(goalName));

      final transactionModel = await repository.getGoalTransactions(
        goalName: goalName,
        iDisplayStart: displayStart,
        iDisplayLength: displayLength,
      );

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final newTransactions = transactionModel.data!.aaData;

        if (loadMore) {
          _allTransactions.addAll(newTransactions);
        } else {
          _allTransactions = newTransactions;
        }

        final totalRecords = transactionModel.data!.iTotalRecords;
        final hasMore = _allTransactions.length < totalRecords;
        ref.read(hasMoreTransactionsProvider(goalName).notifier).state =
            hasMore;

        ref.read(transactionDisplayStartProvider(goalName).notifier).state =
            displayStart + displayLength;

        final updatedModel = GoalTransactionModel(
          status: transactionModel.status,
          data: GoalTransactionData(
            iTotalRecords: transactionModel.data!.iTotalRecords,
            iTotalDisplayRecords: _allTransactions.length,
            aaData: _allTransactions,
          ),
        );

        state = AsyncValue.data(updatedModel);
      } else {
        if (!loadMore) {
          state = AsyncValue.error(
            'Failed to load transactions',
            StackTrace.current,
          );
        }
      }
    } catch (e, stackTrace) {
      if (!loadMore) {
        state = AsyncValue.error(e, stackTrace);
      }
    } finally {
      if (loadMore) {
        ref.read(isLoadingMoreTransactionsProvider(goalName).notifier).state =
            false;
      }
    }
  }

  Future<void> refreshTransactions() async {
    _allTransactions.clear();
    ref.read(transactionDisplayStartProvider(goalName).notifier).state = 0;
    ref.read(hasMoreTransactionsProvider(goalName).notifier).state = true;
    await getGoalTransactions();
  }

  Future<void> loadMoreTransactions() async {
    final hasMore = ref.read(hasMoreTransactionsProvider(goalName));
    final isLoading = ref.read(isLoadingMoreTransactionsProvider(goalName));

    if (hasMore && !isLoading) {
      await getGoalTransactions(loadMore: true);
    }
  }
}
