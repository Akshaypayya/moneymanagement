import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/reusable_sized_box.dart';
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
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(paginatedTransactionProvider.notifier).loadInitialTransactions();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final state = ref.read(paginatedTransactionProvider);

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !state.isLoading &&
        state.hasMore) {
      debugPrint("TRANSACTION: Loading more transactions...");
      ref.read(paginatedTransactionProvider.notifier).loadMoreTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final transactionState = ref.watch(paginatedTransactionProvider);

    debugPrint(
        'TRANSACTIONS PAGE: Current state - ${transactionState.transactions.length} transactions loaded');
    debugPrint('TRANSACTIONS PAGE: isLoading: ${transactionState.isLoading}');
    debugPrint('TRANSACTIONS PAGE: hasMore: ${transactionState.hasMore}');
    debugPrint(
        'TRANSACTIONS PAGE: errorMessage: ${transactionState.errorMessage}');

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
      return _buildLoadingState(isDark);
    }

    if (state.transactions.isEmpty && !state.isLoading) {
      if (state.errorMessage != null) {
        return _buildErrorState(state.errorMessage!, isDark);
      }
      return _buildEmptyState(isDark);
    }

    return _buildTransactionsList(state, isDark);
  }

  Widget _buildTransactionsList(TransactionPaginationState state, bool isDark) {
    final groupedTransactions = _groupTransactionsByMonth(state.transactions);

    debugPrint(
        'TRANSACTIONS PAGE: Processing ${state.transactions.length} transactions');
    for (int i = 0; i < state.transactions.length && i < 5; i++) {
      final tx = state.transactions[i];
      debugPrint('Transaction $i: ${tx.debugInfo}');
    }

    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
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
          _buildFooter(state, isDark),
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
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
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
                  'No transactions found',
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
                  'Your transaction history will appear here once you start investing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[300] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildErrorState(String errorMessage, bool isDark) {
  //   return SingleChildScrollView(
  //     physics: const AlwaysScrollableScrollPhysics(),
  //     child: SizedBox(
  //       height: MediaQuery.of(context).size.height * 0.7,
  //       child: Center(
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Icon(
  //                 Icons.error_outline,
  //                 size: 64,
  //                 color: isDark ? Colors.red[300] : Colors.red,
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 'Error loading transactions',
  //                 style: TextStyle(
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: GoogleFonts.poppins().fontFamily,
  //                   color: isDark ? Colors.white : Colors.black,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               Text(
  //                 errorMessage,
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   fontFamily: GoogleFonts.poppins().fontFamily,
  //                   color: isDark ? Colors.grey[300] : Colors.grey[600],
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               ElevatedButton(
  //                 onPressed: () {
  //                   ref
  //                       .read(paginatedTransactionProvider.notifier)
  //                       .refreshTransactions();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: Colors.teal,
  //                   foregroundColor: Colors.white,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(8),
  //                   ),
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 24, vertical: 12),
  //                 ),
  //                 child: Text(
  //                   'Retry',
  //                   style: TextStyle(
  //                     fontFamily: GoogleFonts.poppins().fontFamily,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildErrorState(String errorMessage, bool isDark) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/nogoal.png',
                  height: 250,
                  width: 250,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.receipt_long_outlined,
                      size: 120,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    );
                  },
                ),
                ReusableText(
                  text: 'Something went wrong',
                  style: AppTextStyle(textColor: AppColors.current(isDark).text)
                      .titleLrg,
                ),
                const SizedBox(height: 20),
                Text(
                  // 'We couldn\'t load your transaction history right now. Please check your connection and try again.',
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
                const SizedBox(height: 36),
                // if (errorMessage.isNotEmpty) ...[
                //   Text(
                //     'Error: $errorMessage',
                //     textAlign: TextAlign.center,
                //     style: TextStyle(
                //       fontSize: 12,
                //       fontFamily: GoogleFonts.poppins().fontFamily,
                //       color: isDark ? Colors.grey[500] : Colors.grey[500],
                //     ),
                //   ),
                //   const SizedBox(height: 24),
                // ],
                // const SizedBox(height: 24),
                // GrowkButton(
                //   title: 'Try Again',
                //   onTap: () {
                //     ref
                //         .read(paginatedTransactionProvider.notifier)
                //         .refreshTransactions();
                //   },
                // ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(TransactionPaginationState state, bool isDark) {
    if (state.isLoading && state.transactions.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
          child: Column(
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            ],
          ),
        ),
      );
    } else if (state.hasMore && state.transactions.isNotEmpty) {
      return const SizedBox(height: 80);
    } else {
      return const SizedBox.shrink();
    }
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
