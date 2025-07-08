import 'package:growk_v2/features/transaction_page/widgets/month_header.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_by_month.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_item.dart';
import 'package:growk_v2/views.dart';

class TransactionListBuilder extends ConsumerStatefulWidget {
  TransactionPaginationState state;
  bool isDark;
  ScrollController scrollController;
  TransactionListBuilder({
    required this.state,
    required this.isDark,
    required this.scrollController,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionListBuilderState();
}

class _TransactionListBuilderState
    extends ConsumerState<TransactionListBuilder> {
  @override
  Widget build(BuildContext context) {
    final groupedTransactions =
        groupTransactionsByMonth(widget.state.transactions, ref);
    final texts = ref.watch(appTextsProvider);

    return SingleChildScrollView(
      controller: widget.scrollController,
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
          if (widget.state.isLoadingMore)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      widget.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          // if (widget.state.transactions.isNotEmpty)
          if (widget.state.transactions.isNotEmpty && !widget.state.hasMore)
            // if (widget.state.transactions.isNotEmpty &&
            // widget.state.transactions.length == widget.state.totalRecords)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 32,
                    color:
                        widget.isDark ? Colors.green[400] : Colors.green[600],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    // 'All ${state.totalRecords} transactions loaded',
                    texts.allTransactionsLoaded,
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          widget.isDark ? Colors.grey[400] : Colors.grey[600],
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
}
