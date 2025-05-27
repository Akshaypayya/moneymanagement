import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_text_styles.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/reusable_row.dart';
import 'package:money_mangmnt/core/widgets/reusable_sized_box.dart';
import 'package:money_mangmnt/core/widgets/reusable_text.dart';
import 'package:money_mangmnt/features/transaction_page/model/transaction_model.dart';

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
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
                ),
                const SizedBox(height: 4),
                ReusableText(
                  text: _formatTransactionDate(),
                  style: AppTextStyle(
                    textColor:
                        isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                  ).labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.translate(
            offset: const Offset(0, 36),
            child: ReusableRow(
              children: [
                Text(
                  transactionData.isDebit ? '-' : '+',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: transactionData.isDebit ? Colors.red : Colors.green,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                Image.asset(
                  AppImages.sarSymbol,
                  height: 16,
                  color: transactionData.isDebit ? Colors.red : Colors.green,
                ),
                const ReusableSizedBox(width: 3),
                ReusableText(
                  text: transactionData.formattedAmount,
                  style: AppTextStyle(
                    textColor:
                        transactionData.isDebit ? Colors.red : Colors.green,
                  ).titleRegular,
                ),
              ],
            ),
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
    if (transactionData.isDebit) {
      return 'The amount is auto-debited from your account and added to your Gold savings.';
    } else {
      return 'Amount credited to your account from ${transactionData.paymentMode}.';
    }
  }

  String _formatTransactionDate() {
    try {
      final date = DateTime.parse(transactionData.transactionDate);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      final day = date.day;
      final month = months[date.month - 1];
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$day $month $displayHour:$minute $period';
    } catch (e) {
      return transactionData.transactionDate;
    }
  }
}
