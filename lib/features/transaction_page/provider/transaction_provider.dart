import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/transaction_page/model/transaction_model.dart';
import 'package:growk_v2/features/transaction_page/repo/transaction_repo.dart';
import 'package:growk_v2/features/transaction_page/controller/transaction_controller.dart';

final transactionNetworkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final networkService = ref.watch(transactionNetworkServiceProvider);
  return TransactionRepository(networkService, ref);
});

final paginatedTransactionProvider = StateNotifierProvider<
    PaginatedTransactionNotifier, TransactionPaginationState>((ref) {
  return PaginatedTransactionNotifier(ref);
});

class TransactionPaginationState {
  final int currentPage;
  final int itemsPerPage;
  final bool isLoading;
  final bool hasMore;
  final List<TransactionApiModel> transactions;
  final int totalRecords;
  final String? errorMessage;

  TransactionPaginationState({
    required this.currentPage,
    required this.itemsPerPage,
    required this.isLoading,
    required this.hasMore,
    required this.transactions,
    required this.totalRecords,
    this.errorMessage,
  });

  TransactionPaginationState copyWith({
    int? currentPage,
    int? itemsPerPage,
    bool? isLoading,
    bool? hasMore,
    List<TransactionApiModel>? transactions,
    int? totalRecords,
    String? errorMessage,
  }) {
    return TransactionPaginationState(
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      transactions: transactions ?? this.transactions,
      totalRecords: totalRecords ?? this.totalRecords,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  String toString() {
    return 'TransactionPaginationState(currentPage: $currentPage, itemsPerPage: $itemsPerPage, isLoading: $isLoading, hasMore: $hasMore, transactionsCount: ${transactions.length}, totalRecords: $totalRecords, errorMessage: $errorMessage)';
  }
}
