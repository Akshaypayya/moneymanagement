import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/features/transaction_page/widgets/month_header.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_by_month.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_item.dart';
import 'package:growk_v2/views.dart';

Widget transactionListBuilder(TransactionPaginationState state, bool isDark,
    ScrollController scrollController, WidgetRef ref) {
  final groupedTransactions = groupTransactionsByMonth(state.transactions);

  return SingleChildScrollView(
    controller: scrollController,
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
