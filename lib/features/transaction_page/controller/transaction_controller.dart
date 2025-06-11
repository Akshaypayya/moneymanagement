import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:growk_v2/features/transaction_page/model/transaction_model.dart';
import 'package:growk_v2/features/transaction_page/provider/transaction_provider.dart';

class PaginatedTransactionNotifier
    extends StateNotifier<TransactionPaginationState> {
  final Ref ref;

  PaginatedTransactionNotifier(this.ref)
      : super(TransactionPaginationState(
          currentPage: 0,
          itemsPerPage: 10, // 10 items per batch
          isLoading: false,
          hasMore: true,
          transactions: [],
          totalRecords: 0,
          isLoadingMore: false,
        ));

  Future<void> loadInitialTransactions() async {
    debugPrint('TRANSACTION PAGINATION: Loading initial 10 transactions');

    state = state.copyWith(
      isLoading: true,
      currentPage: 0,
      transactions: [],
      hasMore: true,
      errorMessage: null,
      isLoadingMore: false,
    );

    try {
      final repository = ref.read(transactionRepositoryProvider);

      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: 0,
        iDisplayLength: state.itemsPerPage,
      );

      debugPrint('TRANSACTION PAGINATION: Initial API call completed');
      debugPrint('TRANSACTION PAGINATION: Status: ${transactionModel.status}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        debugPrint(
            'TRANSACTION PAGINATION: Received ${data.aaData.length} transactions');
        debugPrint(
            'TRANSACTION PAGINATION: Total records: ${data.iTotalRecords}');

        // Check if there are more records to load
        final hasMore = data.aaData.length >= state.itemsPerPage &&
            data.iTotalRecords > data.aaData.length;

        state = state.copyWith(
          isLoading: false,
          transactions: data.aaData,
          totalRecords: data.iTotalRecords,
          hasMore: hasMore,
          currentPage: 1,
          errorMessage: null,
        );

        debugPrint(
            'TRANSACTION PAGINATION: Initial load complete - ${data.aaData.length} items, hasMore: $hasMore');
      } else {
        debugPrint('TRANSACTION PAGINATION: Initial load failed');

        state = state.copyWith(
          isLoading: false,
          transactions: [],
          totalRecords: 0,
          hasMore: false,
          errorMessage: transactionModel.data?.aaData.isEmpty == true
              ? 'No transactions found'
              : 'Failed to load transactions: ${transactionModel.status}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('TRANSACTION PAGINATION ERROR: $e');
      debugPrint('TRANSACTION PAGINATION STACK: $stackTrace');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading transactions: $e',
        hasMore: false,
      );
    }
  }

  Future<void> loadMoreTransactions() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      debugPrint(
          'TRANSACTION PAGINATION: Skipping loadMore - isLoading: ${state.isLoading}, isLoadingMore: ${state.isLoadingMore}, hasMore: ${state.hasMore}');
      return;
    }

    debugPrint('TRANSACTION PAGINATION: Loading more transactions');
    debugPrint(
        'TRANSACTION PAGINATION: Current transactions: ${state.transactions.length}');

    // Calculate start index for next batch
    final startIndex = state.transactions.length;

    state = state.copyWith(isLoadingMore: true);

    try {
      final repository = ref.read(transactionRepositoryProvider);

      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: startIndex,
        iDisplayLength: state.itemsPerPage,
      );

      debugPrint('TRANSACTION PAGINATION: LoadMore API call completed');
      debugPrint('TRANSACTION PAGINATION: Status: ${transactionModel.status}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        final newTransactions = data.aaData;

        debugPrint(
            'TRANSACTION PAGINATION: Received ${newTransactions.length} more transactions');

        // Combine existing with new transactions
        final allTransactions = [...state.transactions, ...newTransactions];

        // Check if there are more records to load
        final hasMore = newTransactions.length >= state.itemsPerPage &&
            allTransactions.length < data.iTotalRecords;

        state = state.copyWith(
          isLoadingMore: false,
          transactions: allTransactions,
          totalRecords: data.iTotalRecords,
          hasMore: hasMore,
          currentPage: state.currentPage + 1,
          errorMessage: null,
        );

        debugPrint(
            'TRANSACTION PAGINATION: LoadMore complete - total: ${allTransactions.length}, hasMore: $hasMore');
      } else {
        debugPrint('TRANSACTION PAGINATION: LoadMore failed');

        state = state.copyWith(
          isLoadingMore: false,
          errorMessage:
              'Failed to load more transactions: ${transactionModel.status}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('TRANSACTION PAGINATION ERROR in loadMore: $e');
      debugPrint('TRANSACTION PAGINATION STACK: $stackTrace');

      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: 'Error loading more transactions: $e',
      );
    }
  }

  Future<void> refreshTransactions() async {
    debugPrint('TRANSACTION PAGINATION: Refreshing transactions');
    await loadInitialTransactions();
  }
}
