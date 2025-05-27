import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:money_mangmnt/features/transaction_page/model/transaction_model.dart';
import 'package:money_mangmnt/features/transaction_page/provider/transaction_provider.dart';

class PaginatedTransactionNotifier
    extends StateNotifier<TransactionPaginationState> {
  final Ref ref;

  PaginatedTransactionNotifier(this.ref)
      : super(TransactionPaginationState(
          currentPage: 0,
          itemsPerPage: 10,
          isLoading: false,
          hasMore: true,
          transactions: [],
          totalRecords: 0,
        ));

  Future<void> loadInitialTransactions() async {
    debugPrint('TRANSACTION PAGINATION: Loading initial transactions');

    state = state.copyWith(
      isLoading: true,
      currentPage: 0,
      transactions: [],
      hasMore: true,
      errorMessage: null,
    );

    debugPrint('TRANSACTION PAGINATION: State set to loading');

    try {
      final repository = ref.read(transactionRepositoryProvider);
      debugPrint('TRANSACTION PAGINATION: Repository obtained');

      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: 0,
        iDisplayLength: state.itemsPerPage,
      );

      debugPrint('TRANSACTION PAGINATION: API call completed');
      debugPrint(
          'TRANSACTION PAGINATION: Model status: ${transactionModel.status}');
      debugPrint(
          'TRANSACTION PAGINATION: Model isSuccess: ${transactionModel.isSuccess}');
      debugPrint(
          'TRANSACTION PAGINATION: Model data null: ${transactionModel.data == null}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        debugPrint(
            'TRANSACTION PAGINATION: Data found - ${data.aaData.length} transactions');
        debugPrint(
            'TRANSACTION PAGINATION: Total records: ${data.iTotalRecords}');

        final newState = state.copyWith(
          isLoading: false,
          transactions: data.aaData,
          totalRecords: data.iTotalRecords,
          hasMore: data.aaData.length < data.iTotalRecords,
          currentPage: 1,
          errorMessage: null,
        );

        debugPrint('TRANSACTION PAGINATION: Setting success state');
        debugPrint(
            'TRANSACTION PAGINATION: New transactions count: ${newState.transactions.length}');
        debugPrint('TRANSACTION PAGINATION: Has more: ${newState.hasMore}');
        debugPrint('TRANSACTION PAGINATION: Is loading: ${newState.isLoading}');

        state = newState;

        debugPrint('TRANSACTION PAGINATION: State updated successfully');
      } else {
        debugPrint(
            'TRANSACTION PAGINATION: API returned non-success status or null data');
        debugPrint(
            'TRANSACTION PAGINATION: Status: ${transactionModel.status}');
        debugPrint(
            'TRANSACTION PAGINATION: Data is null: ${transactionModel.data == null}');

        final errorState = state.copyWith(
          isLoading: false,
          errorMessage: transactionModel.data == null
              ? 'No transaction data received'
              : 'API returned status: ${transactionModel.status}',
          hasMore: false,
        );

        debugPrint('TRANSACTION PAGINATION: Setting error state');
        debugPrint(
            'TRANSACTION PAGINATION: Error message: ${errorState.errorMessage}');

        state = errorState;
      }
    } catch (e, stackTrace) {
      debugPrint('TRANSACTION PAGINATION ERROR: $e');
      debugPrint('TRANSACTION PAGINATION STACK: $stackTrace');

      final errorState = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading transactions: $e',
        hasMore: false,
      );

      debugPrint('TRANSACTION PAGINATION: Setting exception error state');
      state = errorState;
    }

    debugPrint(
        'TRANSACTION PAGINATION: Final state - isLoading: ${state.isLoading}, transactions: ${state.transactions.length}, hasError: ${state.errorMessage != null}');
  }

  Future<void> loadMoreTransactions() async {
    if (state.isLoading || !state.hasMore) {
      debugPrint(
          'TRANSACTION PAGINATION: Skipping loadMore - already loading or no more data');
      return;
    }

    debugPrint(
        'TRANSACTION PAGINATION: Loading more transactions - page ${state.currentPage + 1}');

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(transactionRepositoryProvider);
      final startIndex = state.currentPage * state.itemsPerPage;

      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: startIndex,
        iDisplayLength: state.itemsPerPage,
      );

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        final newTransactions = data.aaData;

        debugPrint(
            'TRANSACTION PAGINATION: Loaded ${newTransactions.length} more transactions');

        final allTransactions = [...state.transactions, ...newTransactions];
        final hasMore = allTransactions.length < data.iTotalRecords;

        state = state.copyWith(
          isLoading: false,
          transactions: allTransactions,
          totalRecords: data.iTotalRecords,
          hasMore: hasMore,
          currentPage: state.currentPage + 1,
          errorMessage: null,
        );

        debugPrint(
            'TRANSACTION PAGINATION: Now showing ${allTransactions.length} transactions, hasMore: $hasMore');
      } else {
        debugPrint('TRANSACTION PAGINATION: Failed to load more transactions');
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load more transactions',
        );
      }
    } catch (e) {
      debugPrint('TRANSACTION PAGINATION ERROR: $e');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refreshTransactions() async {
    debugPrint('TRANSACTION PAGINATION: Refreshing transactions');
    await loadInitialTransactions();
  }
}
