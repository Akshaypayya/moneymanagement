import 'package:growk_v2/views.dart';

class PaginatedTransactionNotifier
    extends StateNotifier<TransactionPaginationState> {
  final Ref ref;

  List<TransactionApiModel> _allTransactions = [];
  int _currentDisplayIndex = 0;
  static const int itemsPerScroll = 10;

  PaginatedTransactionNotifier(this.ref)
      : super(TransactionPaginationState(
          currentPage: 0,
          itemsPerPage: itemsPerScroll,
          isLoading: false,
          hasMore: true,
          transactions: [],
          totalRecords: 0,
          isLoadingMore: false,
        ));

  Future<void> loadInitialTransactions() async {
    debugPrint('CLIENT PAGINATION: Loading all transactions from backend');

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
        iDisplayLength: 1000,
      );

      debugPrint('CLIENT PAGINATION: Backend response completed');

      if (transactionModel.isSuccess && transactionModel.data != null) {
        final data = transactionModel.data!;
        _allTransactions = data.aaData;

        debugPrint(
            'CLIENT PAGINATION: Loaded ${_allTransactions.length} total transactions');
        debugPrint(
            'CLIENT PAGINATION: Backend says total=${data.iTotalRecords}');

        _currentDisplayIndex = 0;

        _updateDisplayedTransactions();
      } else {
        debugPrint('CLIENT PAGINATION: Failed to load transactions');
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'Failed to load transactions: ${transactionModel.status}',
          hasMore: false,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('CLIENT PAGINATION ERROR: $e');
      debugPrint('CLIENT PAGINATION STACK: $stackTrace');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading transactions: $e',
        hasMore: false,
      );
    }
  }

  void onTransactionScroll(ScrollController scrollController) {
    final currentState = state;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      if (currentState.hasMore && !currentState.isAnyLoading) {
        debugPrint("CLIENT PAGINATION: Scroll triggered");
        debugPrint(
            "CLIENT PAGINATION: Currently showing ${currentState.transactions.length}/${_allTransactions.length}");

        loadMoreTransactions();
      }
    }
  }

  Future<void> loadMoreTransactions() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }

    debugPrint('CLIENT PAGINATION: Loading next 10 transactions for display');

    state = state.copyWith(isLoadingMore: true);

    await Future.delayed(const Duration(milliseconds: 500));

    _updateDisplayedTransactions();
  }

  void _updateDisplayedTransactions() {
    final nextDisplayCount = _currentDisplayIndex + itemsPerScroll;
    final endIndex = nextDisplayCount > _allTransactions.length
        ? _allTransactions.length
        : nextDisplayCount;

    final transactionsToShow = _allTransactions.take(endIndex).toList();
    final hasMore = endIndex < _allTransactions.length;

    _currentDisplayIndex = endIndex;

    debugPrint(
        'CLIENT PAGINATION: Now showing ${transactionsToShow.length}/${_allTransactions.length}');
    debugPrint('CLIENT PAGINATION: Has more=$hasMore');

    state = state.copyWith(
      isLoading: false,
      isLoadingMore: false,
      transactions: transactionsToShow,
      totalRecords: _allTransactions.length,
      hasMore: hasMore,
      currentPage: transactionsToShow.length,
      errorMessage: null,
    );
  }

  Future<void> refreshTransactions() async {
    debugPrint('CLIENT PAGINATION: Refreshing transactions');
    _allTransactions.clear();
    _currentDisplayIndex = 0;
    await loadInitialTransactions();
  }

  String get statusInfo {
    if (_allTransactions.isEmpty) return 'No transactions';
    if (state.transactions.length >= _allTransactions.length) {
      return 'Showing all ${_allTransactions.length} transactions';
    }
    return 'Showing ${state.transactions.length} of ${_allTransactions.length} transactions';
  }

  void debugCurrentState() {
    debugPrint('CLIENT PAGINATION DEBUG:');
    debugPrint('  - Total loaded from backend: ${_allTransactions.length}');
    debugPrint('  - Currently displayed: ${state.transactions.length}');
    debugPrint('  - Current display index: $_currentDisplayIndex');
    debugPrint('  - Has more: ${state.hasMore}');
    debugPrint('  - Is loading: ${state.isLoading}');
    debugPrint('  - Is loading more: ${state.isLoadingMore}');
  }
}
