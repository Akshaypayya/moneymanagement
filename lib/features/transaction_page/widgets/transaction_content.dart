import 'package:growk_v2/features/transaction_page/widgets/transaction_empty_state.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_error_widget.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_loading_state.dart';
import 'package:growk_v2/features/transaction_page/widgets/transaction_show_list.dart';
import 'package:growk_v2/views.dart';

Widget transactionContentBuilder(TransactionPaginationState state, bool isDark,
    ScrollController scrollController, BuildContext context, WidgetRef ref) {
  if (state.transactions.isEmpty && state.isLoading) {
    debugPrint("TRANSACTIONS PAGE: Displaying initial loading state");
    return transactionLoadingState(isDark, ref);
  }

  if (state.transactions.isEmpty && state.errorMessage != null) {
    debugPrint(
        "TRANSACTIONS PAGE: Displaying error state: ${state.errorMessage}");
    return buildTransactionErrorState(
        state.errorMessage!, isDark, context, ref);
  }

  if (state.transactions.isEmpty && !state.isLoading) {
    debugPrint("TRANSACTIONS PAGE: Displaying empty state");
    return transactionEmptyState(isDark, context, ref);
  }

  debugPrint(
      "TRANSACTIONS PAGE: Displaying ${state.transactions.length} transactions");
  return TransactionListBuilder(
    state: state,
    isDark: isDark,
    scrollController: scrollController,
  );
  // return transactionListBuilder(state, isDark, scrollController, ref);
}
