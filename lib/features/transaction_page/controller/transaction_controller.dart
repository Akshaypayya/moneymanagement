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
          itemsPerPage: 10, // 10 items per page
          isLoading: false,
          hasMore: true,
          transactions: [],
          totalRecords: 0,
          isLoadingMore: false,
        ));

  Future<void> loadInitialTransactions() async {
    debugPrint(
        'TRANSACTION PAGINATION: Loading initial 10 transactions (page 0)');

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

      // Start from the beginning: iDisplayStart=0, iDisplayLength=10
      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: 0,
        iDisplayLength: state.itemsPerPage,
      );

      debugPrint('TRANSACTION PAGINATION: Initial API call completed');
      debugPrint('TRANSACTION PAGINATION: Status: ${transactionModel.status}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        final loadedTransactions = data.aaData;

        debugPrint(
            'TRANSACTION PAGINATION: Received ${loadedTransactions.length} transactions');
        debugPrint(
            'TRANSACTION PAGINATION: Total available: ${data.iTotalRecords}');
        debugPrint(
            'TRANSACTION PAGINATION: iTotalDisplayRecords: ${data.iTotalDisplayRecords}');

        // Check for backend issues
        if (loadedTransactions.isEmpty && data.iTotalRecords > 0) {
          debugPrint(
              'TRANSACTION PAGINATION: ⚠️ BACKEND ISSUE: iTotalRecords=${data.iTotalRecords} but received empty aaData');
          state = state.copyWith(
            isLoading: false,
            transactions: [],
            totalRecords: data.iTotalRecords,
            hasMore: false,
            errorMessage:
                'Backend issue: ${data.iTotalRecords} transactions available but none returned. This suggests a pagination parameter mismatch.',
          );
          return;
        }

        // Normal success case
        if (loadedTransactions.isNotEmpty) {
          // Determine if there are more records to load
          final hasMore = data.iTotalRecords > loadedTransactions.length;

          state = state.copyWith(
            isLoading: false,
            transactions: loadedTransactions,
            totalRecords: data.iTotalRecords,
            hasMore: hasMore,
            currentPage: 1, // We've loaded page 1
            errorMessage: null,
          );

          debugPrint('TRANSACTION PAGINATION: Initial load complete');
          debugPrint(
              'TRANSACTION PAGINATION: Loaded ${loadedTransactions.length} items');
          debugPrint('TRANSACTION PAGINATION: Has more: $hasMore');
          debugPrint(
              'TRANSACTION PAGINATION: Total records: ${data.iTotalRecords}');
        } else {
          // Empty but no error - legitimate empty state
          state = state.copyWith(
            isLoading: false,
            transactions: [],
            totalRecords: 0,
            hasMore: false,
            errorMessage: null,
          );
          debugPrint(
              'TRANSACTION PAGINATION: No transactions available (legitimate empty state)');
        }
      } else {
        debugPrint(
            'TRANSACTION PAGINATION: Initial load failed - ${transactionModel.status}');

        final isEmpty = transactionModel.data?.aaData.isEmpty == true;
        state = state.copyWith(
          isLoading: false,
          transactions: [],
          totalRecords: transactionModel.data?.iTotalRecords ?? 0,
          hasMore: false,
          errorMessage: isEmpty
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
      debugPrint('TRANSACTION PAGINATION: Skipping loadMore - '
          'isLoading: ${state.isLoading}, '
          'isLoadingMore: ${state.isLoadingMore}, '
          'hasMore: ${state.hasMore}');
      return;
    }

    debugPrint('TRANSACTION PAGINATION: Loading more transactions');
    debugPrint(
        'TRANSACTION PAGINATION: Current loaded: ${state.transactions.length}');
    debugPrint(
        'TRANSACTION PAGINATION: Total available: ${state.totalRecords}');

    // Calculate the next batch start index
    // Since we already have state.transactions.length items,
    // the next batch should start at that index
    final nextStartIndex = state.transactions.length;

    debugPrint(
        'TRANSACTION PAGINATION: Requesting next ${state.itemsPerPage} items starting from index $nextStartIndex');

    state = state.copyWith(isLoadingMore: true);

    try {
      final repository = ref.read(transactionRepositoryProvider);

      // Request next batch: iDisplayStart = current length, iDisplayLength = 10
      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: nextStartIndex,
        iDisplayLength: state.itemsPerPage,
      );

      debugPrint('TRANSACTION PAGINATION: LoadMore API call completed');
      debugPrint('TRANSACTION PAGINATION: Status: ${transactionModel.status}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        final newTransactions = data.aaData;

        debugPrint(
            'TRANSACTION PAGINATION: Received ${newTransactions.length} more transactions');

        if (newTransactions.isEmpty) {
          debugPrint('TRANSACTION PAGINATION: Received empty response');
          debugPrint(
              'TRANSACTION PAGINATION: Current loaded: ${state.transactions.length}');
          debugPrint(
              'TRANSACTION PAGINATION: Total available: ${data.iTotalRecords}');

          // Check if we should have more data
          if (state.transactions.length < data.iTotalRecords) {
            debugPrint(
                'TRANSACTION PAGINATION: ⚠️ BACKEND ISSUE: Expected more data but got empty array');
            debugPrint(
                'TRANSACTION PAGINATION: Expected: ${data.iTotalRecords - state.transactions.length} more transactions');

            // This suggests a backend pagination issue - don't mark as complete
            state = state.copyWith(
              isLoadingMore: false,
              hasMore: false, // Stop trying since backend is not returning data
              errorMessage:
                  'Backend pagination issue: Expected ${data.iTotalRecords - state.transactions.length} more transactions but received empty response',
              totalRecords: data.iTotalRecords,
            );
          } else {
            debugPrint(
                'TRANSACTION PAGINATION: All transactions loaded successfully');
            state = state.copyWith(
              isLoadingMore: false,
              hasMore: false,
              totalRecords: data.iTotalRecords,
            );
          }
          return;
        }

        // Combine existing with new transactions
        final allTransactions = [...state.transactions, ...newTransactions];

        // Check if there are more records to load
        // We have more if: our total loaded < backend's total records
        final hasMore = allTransactions.length < data.iTotalRecords;

        state = state.copyWith(
          isLoadingMore: false,
          transactions: allTransactions,
          totalRecords: data.iTotalRecords,
          hasMore: hasMore,
          currentPage: state.currentPage + 1,
          errorMessage: null,
        );

        debugPrint('TRANSACTION PAGINATION: LoadMore complete');
        debugPrint(
            'TRANSACTION PAGINATION: Total loaded: ${allTransactions.length}');
        debugPrint('TRANSACTION PAGINATION: Has more: $hasMore');
        debugPrint(
            'TRANSACTION PAGINATION: Total available: ${data.iTotalRecords}');
      } else {
        debugPrint(
            'TRANSACTION PAGINATION: LoadMore failed - ${transactionModel.status}');

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
    debugPrint(
        'TRANSACTION PAGINATION: Refreshing transactions (clearing all data)');
    await loadInitialTransactions();
  }

  // Helper method to get current status info
  String get statusInfo {
    if (state.totalRecords == 0) return 'No transactions';
    if (state.transactions.length >= state.totalRecords) {
      return 'Showing all ${state.totalRecords} transactions';
    }
    return 'Showing ${state.transactions.length} of ${state.totalRecords} transactions';
  }

  // Debug method to print current state
  void debugCurrentState() {
    debugPrint('TRANSACTION STATE DEBUG:');
    debugPrint('  - Current page: ${state.currentPage}');
    debugPrint('  - Items per page: ${state.itemsPerPage}');
    debugPrint('  - Loaded transactions: ${state.transactions.length}');
    debugPrint('  - Total records: ${state.totalRecords}');
    debugPrint('  - Has more: ${state.hasMore}');
    debugPrint('  - Is loading: ${state.isLoading}');
    debugPrint('  - Is loading more: ${state.isLoadingMore}');
    debugPrint('  - Error message: ${state.errorMessage}');
  }
}
