import 'package:growk_v2/features/transaction_page/widgets/transctn_fns.dart';
import 'package:growk_v2/views.dart';

class TransactionItemMainBody extends ConsumerWidget {
  final TransactionApiModel transactionData;
  const TransactionItemMainBody({required this.transactionData, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;

    debugPrint('Transaction Item Debug: ${transactionData.debugInfo}');

    Color amountColor = isDark ? Colors.white : Colors.black;
    Color sarSymbolColor = AppColors.current(isDark).primary;
    String amountSign = '';

    if (transactionData.isCredit) {
      amountColor = Colors.green;
      sarSymbolColor = Colors.green;
      amountSign = '+';
    } else if (transactionData.isDebit) {
      amountColor = Colors.red;
      sarSymbolColor = Colors.red;
      amountSign = '-';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.current(!isDark).background,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: buildTransactionIcon(transactionData),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: getTransactionCategory(transactionData),
                  style: AppTextStyle(textColor: textColor).titleRegular,
                ),
                const SizedBox(height: 4),
                Text(
                  getTransactionDescription(transactionData),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.current(isDark).text,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                ReusableText(
                  text: getTransactionFormattedDate(transactionData),
                  style: AppTextStyle(
                    textColor:
                        isDark ? Colors.grey.shade500 : Colors.grey.shade700,
                  ).labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ReusableRow(
                children: [
                  if (amountSign.isNotEmpty)
                    Text(
                      amountSign,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                      ),
                    ),
                  transactionData.currencyCode == "XAU"
                      ? const SizedBox()
                      : Image.asset(
                          AppImages.sarSymbol,
                          height: 16,
                          color: sarSymbolColor,
                        ),
                  const ReusableSizedBox(width: 3),
                  ReusableText(
                    // text: transactionData.formattedAmount,
                    text: transactionData.currencyCode == "XAU"
                        ? "${transactionData.amount.toStringAsFixed(2)} gm"
                        : transactionData.amount.toStringAsFixed(2),
                    style: AppTextStyle(textColor: amountColor).titleRegular,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
