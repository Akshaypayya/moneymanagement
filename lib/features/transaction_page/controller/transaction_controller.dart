import 'package:growk_v2/views.dart';

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
          isLoadingMore: false,
        ));

  Future<void> loadInitialTransactions() async {
    debugPrint(
        'TRANSACTION PAGINATION: Loading initial 10 transactions (iDisplayStart=0)');

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
        iDisplayLength: 10,
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

        if (loadedTransactions.isEmpty && data.iTotalRecords > 0) {
          debugPrint(
              'TRANSACTION PAGINATION: ⚠️ BACKEND ISSUE: iTotalRecords=${data.iTotalRecords} but received empty aaData');
          state = state.copyWith(
            isLoading: false,
            transactions: [],
            totalRecords: data.iTotalRecords,
            hasMore: false,
            errorMessage:
                'Backend issue: ${data.iTotalRecords} transactions available but none returned.',
          );
          return;
        }

        if (loadedTransactions.isNotEmpty) {
          final hasMore = loadedTransactions.length < data.iTotalRecords;

          state = state.copyWith(
            isLoading: false,
            transactions: loadedTransactions,
            totalRecords: data.iTotalRecords,
            hasMore: hasMore,
            currentPage: 1,
            errorMessage: null,
          );

          debugPrint('TRANSACTION PAGINATION: Initial load complete');
          debugPrint(
              'TRANSACTION PAGINATION: Loaded ${loadedTransactions.length} items');
          debugPrint('TRANSACTION PAGINATION: Has more: $hasMore');
          debugPrint(
              'TRANSACTION PAGINATION: Total records: ${data.iTotalRecords}');
        } else {
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

  void onTransactionScroll(ScrollController scrollController) {
    final state = ref.read(paginatedTransactionProvider);

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (state.hasMore && !state.isAnyLoading) {
        debugPrint(
            "TRANSACTIONS PAGE: Scroll triggered - loading next ${state.itemsPerPage} items");
        debugPrint(
            "TRANSACTIONS PAGE: Current items: ${state.transactions.length}/${state.totalRecords}");
        debugPrint(
            "TRANSACTIONS PAGE: Next request will be: iDisplayStart=${state.transactions.length}, iDisplayLength=${state.itemsPerPage}");

        ref.read(paginatedTransactionProvider.notifier).loadMoreTransactions();
      } else {
        if (!state.hasMore) {
          debugPrint(
              "TRANSACTIONS PAGE: All transactions loaded (${state.transactions.length}/${state.totalRecords})");
        } else if (state.isAnyLoading) {
          debugPrint(
              "TRANSACTIONS PAGE: Already loading, skipping scroll trigger");
        }
      }
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

    final nextDisplayStart = state.currentPage;

    debugPrint(
        'TRANSACTION PAGINATION: Requesting next 10 items with iDisplayStart=$nextDisplayStart');

    state = state.copyWith(isLoadingMore: true);

    try {
      final repository = ref.read(transactionRepositoryProvider);

      final transactionModel = await repository.getAllTransactions(
        iDisplayStart: nextDisplayStart,
        iDisplayLength: 10,
      );

      debugPrint('TRANSACTION PAGINATION: LoadMore API call completed');
      debugPrint('TRANSACTION PAGINATION: Status: ${transactionModel.status}');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        final newTransactions = data.aaData;

        debugPrint(
            'TRANSACTION PAGINATION: Received ${newTransactions.length} more transactions');

        if (newTransactions.isEmpty) {
          debugPrint(
              'TRANSACTION PAGINATION: Received empty response - no more data');
          state = state.copyWith(
            isLoadingMore: false,
            hasMore: false,
            totalRecords: data.iTotalRecords,
          );
          return;
        }

        final allTransactions = [...state.transactions, ...newTransactions];

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
            'TRANSACTION PAGINATION: Next iDisplayStart will be: ${state.currentPage}');
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

  String get statusInfo {
    if (state.totalRecords == 0) return 'No transactions';
    if (state.transactions.length >= state.totalRecords) {
      return 'Showing all ${state.totalRecords} transactions';
    }
    return 'Showing ${state.transactions.length} of ${state.totalRecords} transactions';
  }

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
    debugPrint('  - Next iDisplayStart will be: ${state.currentPage}');
  }
}
