import 'package:growk_v2/features/transaction_page/widgets/month_data.dart';
import 'package:growk_v2/views.dart';

Map<Map<String, String>, List<TransactionApiModel>> groupTransactionsByMonth(
    List<TransactionApiModel> transactions, WidgetRef ref) {
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
        'month': getTransactionMonthName(date.month, ref),
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
