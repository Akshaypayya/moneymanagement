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
          itemsPerPage: 100,
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

        final hasMore = data.aaData.length < data.iTotalRecords;
        debugPrint('TRANSACTION PAGINATION: Has more data: $hasMore');

        final newState = state.copyWith(
          isLoading: false,
          transactions: data.aaData,
          totalRecords: data.iTotalRecords,
          hasMore: hasMore,
          currentPage: 1,
          errorMessage: null,
        );

        debugPrint('TRANSACTION PAGINATION: Setting success state');
        debugPrint(
            'TRANSACTION PAGINATION: New transactions count: ${newState.transactions.length}');
        debugPrint('TRANSACTION PAGINATION: Has more: ${newState.hasMore}');
        debugPrint(
            'TRANSACTION PAGINATION: Current page: ${newState.currentPage}');

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
          'TRANSACTION PAGINATION: Skipping loadMore - isLoading: ${state.isLoading}, hasMore: ${state.hasMore}');
      return;
    }

    debugPrint(
        'TRANSACTION PAGINATION: Loading more transactions - page ${state.currentPage}');
    debugPrint(
        'TRANSACTION PAGINATION: Current transactions count: ${state.transactions.length}');
    debugPrint('TRANSACTION PAGINATION: Total records: ${state.totalRecords}');

    final startIndex = state.transactions.length;
    debugPrint('TRANSACTION PAGINATION: Start index: $startIndex');

    state = state.copyWith(isLoading: true);

    try {
      final repository = ref.read(transactionRepositoryProvider);

      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: startIndex,
        iDisplayLength: state.itemsPerPage,
      );

      debugPrint('TRANSACTION PAGINATION: Load more API call completed');
      debugPrint(
          'TRANSACTION PAGINATION: Response status: ${transactionModel.status}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        final newTransactions = data.aaData;

        debugPrint(
            'TRANSACTION PAGINATION: Loaded ${newTransactions.length} more transactions');

        final allTransactions = [...state.transactions, ...newTransactions];
        final hasMore = allTransactions.length < data.iTotalRecords;

        debugPrint(
            'TRANSACTION PAGINATION: Total transactions now: ${allTransactions.length}');
        debugPrint(
            'TRANSACTION PAGINATION: Total records available: ${data.iTotalRecords}');
        debugPrint(
            'TRANSACTION PAGINATION: Has more after this load: $hasMore');

        state = state.copyWith(
          isLoading: false,
          transactions: allTransactions,
          totalRecords: data.iTotalRecords,
          hasMore: hasMore,
          currentPage: state.currentPage + 1,
          errorMessage: null,
        );

        debugPrint(
            'TRANSACTION PAGINATION: Successfully loaded more. Now showing ${allTransactions.length} transactions, hasMore: $hasMore');
      } else {
        debugPrint('TRANSACTION PAGINATION: Failed to load more transactions');
        debugPrint(
            'TRANSACTION PAGINATION: API Status: ${transactionModel.status}');

        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to load more transactions: ${transactionModel.status}',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('TRANSACTION PAGINATION ERROR in loadMore: $e');
      debugPrint('TRANSACTION PAGINATION STACK: $stackTrace');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading more transactions: $e',
      );
    }
  }
  // Future<void> loadMoreTransactions() async {
  //   if (state.isLoading || !state.hasMore) return;

  //   final startIndex = state.transactions.length;
  //   state = state.copyWith(isLoading: true);

  //   try {
  //     final repo = ref.read(transactionRepositoryProvider);
  //     final transactionModel = await repo.getAllTransactions(
  //       iDisplayStart: startIndex,
  //       iDisplayLength: state.itemsPerPage,
  //     );

  //     if (transactionModel.isSuccess && transactionModel.data != null) {
  //       final data = transactionModel.data!;
  //       final newTransactions = data.aaData;
  //       final allTransactions = [...state.transactions, ...newTransactions];
  //       final hasMore = allTransactions.length < data.iTotalRecords;

  //       state = state.copyWith(
  //         isLoading: false,
  //         transactions: allTransactions,
  //         totalRecords: data.iTotalRecords,
  //         hasMore: hasMore,
  //         currentPage: state.currentPage + 1,
  //         errorMessage: null,
  //       );
  //     } else {
  //       state = state.copyWith(
  //         isLoading: false,
  //         errorMessage: transactionModel.message ?? 'Unknown error',
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     state = state.copyWith(
  //       isLoading: false,
  //       errorMessage: e.toString(),
  //     );
  //   }
  // }

  Future<void> refreshTransactions() async {
    debugPrint('TRANSACTION PAGINATION: Refreshing transactions');
    await loadInitialTransactions();
  }
}
