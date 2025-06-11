import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/features/transaction_page/widgets/month_header.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_item.dart';
import 'package:growk_v2/features/transaction_page/provider/transaction_provider.dart';
import 'package:growk_v2/features/transaction_page/model/transaction_model.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint(
          "TRANSACTIONS PAGE: Initializing - loading first 10 transactions");
      ref.read(paginatedTransactionProvider.notifier).loadInitialTransactions();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(paginatedTransactionProvider);

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
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

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final transactionState = ref.watch(paginatedTransactionProvider);

    debugPrint('TRANSACTIONS PAGE BUILD: ${transactionState.toString()}');

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        appBar: GrowkAppBar(
          title: 'Transactions',
          isBackBtnNeeded: false,
        ),
        body: Container(
          color: AppColors.current(isDark).background,
          child: RefreshIndicator(
            onRefresh: () async {
              debugPrint("TRANSACTIONS PAGE: Pull to refresh triggered");
              await ref
                  .read(paginatedTransactionProvider.notifier)
                  .refreshTransactions();
            },
            child: _buildTransactionContent(transactionState, isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionContent(
      TransactionPaginationState state, bool isDark) {
    if (state.transactions.isEmpty && state.isLoading) {
      debugPrint("TRANSACTIONS PAGE: Displaying initial loading state");
      return _buildLoadingState(isDark);
    }

    if (state.transactions.isEmpty && state.errorMessage != null) {
      debugPrint(
          "TRANSACTIONS PAGE: Displaying error state: ${state.errorMessage}");
      return _buildErrorState(state.errorMessage!, isDark);
    }

    if (state.transactions.isEmpty && !state.isLoading) {
      debugPrint("TRANSACTIONS PAGE: Displaying empty state");
      return _buildEmptyState(isDark);
    }

    debugPrint(
        "TRANSACTIONS PAGE: Displaying ${state.transactions.length} transactions");
    return _buildTransactionsList(state, isDark);
  }

  Widget _buildTransactionsList(TransactionPaginationState state, bool isDark) {
    final groupedTransactions = _groupTransactionsByMonth(state.transactions);

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          if (groupedTransactions.isNotEmpty)
            ...groupedTransactions.entries.map((entry) {
              final monthYear = entry.key;
              final transactions = entry.value;

              return Column(
                children: [
                  MonthHeader(
                    year: monthYear['year']!,
                    month: monthYear['month']!,
                  ),
                  ...transactions.map((transactionData) => TransactionItem(
                        transactionData: transactionData,
                      )),
                ],
              );
            }),
          if (state.isLoadingMore)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  // const SizedBox(height: 12),
                  // Text(
                  //   // state.loadingMessage,
                  //   'Loading More Transactions',
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: isDark ? Colors.grey[400] : Colors.grey[600],
                  //     fontFamily: GoogleFonts.poppins().fontFamily,
                  //   ),
                  // ),
                ],
              ),
            ),
          if (state.hasMore &&
              !state.isLoadingMore &&
              state.transactions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    debugPrint("TRANSACTIONS PAGE: Load more button pressed");
                    debugPrint(
                        "TRANSACTIONS PAGE: Will load next ${state.itemsPerPage} items (${state.transactions.length + state.itemsPerPage} total)");
                    ref
                        .read(paginatedTransactionProvider.notifier)
                        .loadMoreTransactions();
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Load Next ${state.itemsPerPage} Transactions',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
              ),
            ),
          if (!state.hasMore && state.transactions.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 32,
                    color: isDark ? Colors.green[400] : Colors.green[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // 'All ${state.totalRecords} transactions loaded',
                    'All transactions loaded',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Loading your transactions...',
            style: TextStyle(
              color: isDark ? Colors.grey[300] : Colors.grey[600],
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: isDark ? Colors.grey[600] : Colors.grey[400],
                ),
                const SizedBox(height: 20),
                Text(
                  'No Transactions Yet',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your transaction history will appear here once you start investing in goals and making transactions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, bool isDark) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/nogoal.png',
                  height: 200,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.error_outline,
                      size: 80,
                      color: isDark ? Colors.red[300] : Colors.red,
                    );
                  },
                ),
                const SizedBox(height: 20),
                ReusableText(
                  text: 'Something went wrong',
                  style: AppTextStyle(textColor: AppColors.current(isDark).text)
                      .titleLrg,
                ),
                const SizedBox(height: 20),
                Text(
                  errorMessage,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 16),
                GrowkButton(
                  title: 'Retry',
                  onTap: () {
                    debugPrint("TRANSACTIONS PAGE: Retry button pressed");
                    ref
                        .read(paginatedTransactionProvider.notifier)
                        .refreshTransactions();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Map<Map<String, String>, List<TransactionApiModel>> _groupTransactionsByMonth(
      List<TransactionApiModel> transactions) {
    final Map<Map<String, String>, List<TransactionApiModel>> grouped = {};

    final sortedTransactions = List<TransactionApiModel>.from(transactions);
    sortedTransactions.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.transactionDate);
        final dateB = DateTime.parse(b.transactionDate);
        return dateB.compareTo(dateA);
      } catch (e) {
        return 0;
      }
    });

    for (final transaction in sortedTransactions) {
      try {
        final date = DateTime.parse(transaction.transactionDate);
        final monthYear = {
          'year': date.year.toString(),
          'month': _getMonthName(date.month),
        };

        Map<String, String>? existingKey;
        for (final key in grouped.keys) {
          if (key['year'] == monthYear['year'] &&
              key['month'] == monthYear['month']) {
            existingKey = key;
            break;
          }
        }

        if (existingKey != null) {
          grouped[existingKey]!.add(transaction);
        } else {
          grouped[monthYear] = [transaction];
        }
      } catch (e) {
        debugPrint(
            'Error parsing transaction date: ${transaction.transactionDate}');

        final unknownKey = {'year': 'Unknown', 'month': 'Unknown'};
        Map<String, String>? existingUnknownKey;
        for (final key in grouped.keys) {
          if (key['year'] == 'Unknown' && key['month'] == 'Unknown') {
            existingUnknownKey = key;
            break;
          }
        }

        if (existingUnknownKey != null) {
          grouped[existingUnknownKey]!.add(transaction);
        } else {
          grouped[unknownKey] = [transaction];
        }
      }
    }

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) {
        try {
          final dateA = DateTime.parse(a.transactionDate);
          final dateB = DateTime.parse(b.transactionDate);
          return dateB.compareTo(dateA);
        } catch (e) {
          return 0;
        }
      });
    }

    return grouped;
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return 'Unknown';
  }
}
