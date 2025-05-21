import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_transaction_item.dart';

class TransactionList extends ConsumerWidget {
  final List<Map<String, String>> transactions;

  const TransactionList({
    Key? key,
    required this.transactions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: transactions.map((transaction) {
        return GoalDetailTransactionItem(
          icon: transaction['icon']!,
          title: transaction['title']!,
          description: transaction['description']!,
          amount: transaction['amount']!,
          date: transaction['date']!,
        );
      }).toList(),
    );
  }
}
