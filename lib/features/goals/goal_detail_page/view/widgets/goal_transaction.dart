import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_transaction_item.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_transaction_model.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/provider/goal_transaction_provider.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_transaction_item.dart';

class GoalTransactionListWidget extends ConsumerStatefulWidget {
  final String goalName;

  const GoalTransactionListWidget({
    Key? key,
    required this.goalName,
  }) : super(key: key);

  @override
  ConsumerState<GoalTransactionListWidget> createState() =>
      _GoalTransactionListWidgetState();
}

class _GoalTransactionListWidgetState
    extends ConsumerState<GoalTransactionListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref
          .read(goalTransactionStateProvider(widget.goalName).notifier)
          .loadMoreTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final transactionState =
        ref.watch(goalTransactionStateProvider(widget.goalName));
    final isLoadingMore =
        ref.watch(isLoadingMoreTransactionsProvider(widget.goalName));
    final hasMore = ref.watch(hasMoreTransactionsProvider(widget.goalName));

    return Container(
      // height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 10.0, top: 30.0),
            child: Text(
              'Transactions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          transactionState.when(
            loading: () => _buildLoadingState(isDark),
            error: (error, stackTrace) =>
                _buildErrorState(error.toString(), isDark),
            data: (transactionModel) => _buildTransactionList(
                transactionModel, isDark, isLoadingMore, hasMore),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isDark) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.white : Colors.black,
            ),
          ),
          // const SizedBox(height: 16),
          // Text(
          //   'Loading transactions...',
          //   style: TextStyle(
          //     color: isDark ? Colors.grey[300] : Colors.grey[600],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: isDark ? Colors.red[300] : Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load transactions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(goalTransactionStateProvider(widget.goalName).notifier)
                  .refreshTransactions();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(
    GoalTransactionModel transactionModel,
    bool isDark,
    bool isLoadingMore,
    bool hasMore,
  ) {
    if (transactionModel.data == null ||
        transactionModel.data!.aaData.isEmpty) {
      return _buildEmptyState(isDark);
    }

    final transactions = transactionModel.data!.aaData;

    return Column(
      children: [
        ListView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            return GoalDetailTransactionItem(
              icon: transaction.iconAsset,
              title: transaction.transactionType,
              description: transaction.description,
              amount: transaction.displayAmount,
              // date: transaction.formattedDate,
              date: transaction.getFormattedDate(),
            );
          },
        ),
        // Container(height: 100, color: Colors.red),
        if (isLoadingMore)
          Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        // if (!hasMore && transactions.isNotEmpty)
        //   Container(
        //     padding: const EdgeInsets.all(16),
        //     alignment: Alignment.center,
        //     child: Text(
        //       'No more transactions',
        //       style: TextStyle(
        //         color: isDark ? Colors.grey[400] : Colors.grey[600],
        //         fontStyle: FontStyle.italic,
        //       ),
        //     ),
        //   ),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      height: 200,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
          const SizedBox(height: 16),
          Text(
            'No Transactions Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
