import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/reusable_row.dart';
import 'package:growk_v2/core/widgets/reusable_sized_box.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/features/transaction_page/model/transaction_model.dart';
import 'package:intl/intl.dart';

class TransactionItem extends ConsumerWidget {
  final TransactionApiModel transactionData;

  const TransactionItem({
    Key? key,
    required this.transactionData,
  }) : super(key: key);

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
              child: _buildTransactionIcon(),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: _getTransactionCategory(),
                  style: AppTextStyle(textColor: textColor).titleRegular,
                ),
                const SizedBox(height: 4),
                Text(
                  _getTransactionDescription(),
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
                  text: getFormattedDate(),
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

  Widget _buildTransactionIcon() {
    String iconAsset = _getTransactionIconAsset();

    return Image.asset(
      iconAsset,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          _getTransactionIconData(),
          size: 24,
          color: Colors.grey,
        );
      },
    );
  }

  String _getTransactionIconAsset() {
    final subGroup = transactionData.accountSubGroup.toLowerCase();
    final paymentMode = transactionData.paymentMode.toLowerCase();
    final transactionCode = transactionData.transactionCode.toLowerCase();

    if (transactionData.isCredit && transactionData.currencyCode == 'XAU') {
      return 'assets/goldbsct.png';
    }

    if (subGroup.contains('education') || subGroup.contains('study')) {
      return 'assets/education.png';
    } else if (subGroup.contains('home') || subGroup.contains('house')) {
      return 'assets/home.png';
    } else if (subGroup.contains('wedding') || subGroup.contains('marriage')) {
      return 'assets/wedding.png';
    } else if (subGroup.contains('trip') || subGroup.contains('travel')) {
      return 'assets/trip.png';
    } else if (paymentMode.contains('upi')) {
      return 'assets/bhim.png';
    } else if (paymentMode.contains('bank') ||
        paymentMode.contains('netbanking')) {
      return 'assets/bank.jpg';
    } else if (paymentMode.contains('gold') ||
        transactionCode.contains('gold')) {
      return 'assets/goldbsct.png';
    } else {
      return 'assets/customgoals.png';
    }
  }

  IconData _getTransactionIconData() {
    switch (transactionData.paymentMode.toLowerCase()) {
      case 'upi':
        return Icons.account_balance_wallet;
      case 'bank':
      case 'netbanking':
        return Icons.account_balance;
      case 'gold':
        return Icons.stars;
      default:
        return Icons.payment;
    }
  }

  String _getTransactionCategory() {
    if (transactionData.accountSubGroup.isNotEmpty) {
      return transactionData.accountSubGroup
          .split(' ')
          .map((word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : word)
          .join(' ');
    }

    return transactionData.paymentMode.toUpperCase();
  }

  String _getTransactionDescription() {
    return transactionData.transactionDescription;
  }

  getFormattedDate() {
    String dateStr = transactionData.transactionDate;
    DateTime utcTime = DateTime.parse(dateStr);
    DateTime localTime = utcTime.toLocal();
    String formatted = DateFormat('dd MMM yyyy – hh:mm a').format(localTime);
    return formatted;
  }
}
