import 'package:growk_v2/views.dart';

class TransactionItem extends ConsumerWidget {
  final TransactionApiModel transactionData;

  const TransactionItem({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TransactionItemMainBody(
      transactionData: transactionData,
    );
  }
}
