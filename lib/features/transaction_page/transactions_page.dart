import 'package:growk_v2/features/transaction_page/widgets/transaction_content.dart';
import 'package:growk_v2/views.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    ref
        .read(paginatedTransactionProvider.notifier)
        .onTransactionScroll(_scrollController);
  }

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
            child: transactionContentBuilder(
                transactionState, isDark, _scrollController, context, ref),
          ),
        ),
      ),
    );
  }
}
