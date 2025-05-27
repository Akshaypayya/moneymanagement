import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/transaction_page/model/transaction_model.dart';
import 'package:money_mangmnt/features/transaction_page/repo/transaction_repo.dart';
import 'package:money_mangmnt/features/transaction_page/controller/transaction_controller.dart';

// Network service provider
final transactionNetworkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
});

// Repository provider
final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  final networkService = ref.watch(transactionNetworkServiceProvider);
  return TransactionRepository(networkService, ref);
});

// Paginated transaction state notifier provider
final paginatedTransactionProvider = StateNotifierProvider<
    PaginatedTransactionNotifier, TransactionPaginationState>((ref) {
  return PaginatedTransactionNotifier(ref);
});

// Transaction pagination state class
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
}
