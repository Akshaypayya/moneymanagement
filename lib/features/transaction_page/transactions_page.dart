import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/core/widgets/reusable_sized_box.dart';
import 'package:money_mangmnt/features/transaction_page/widgets/month_header.dart';
import 'package:money_mangmnt/features/transaction_page/widgets/transaction_item.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        appBar: GrowkAppBar(
          title: 'Transactions',
          isBackBtnNeeded: false,
        ),
        body: Container(
          // color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
          color: AppColors.current(isDark).background,
          child: SingleChildScrollView(
            child: Column(
              children: [
                MonthHeader(year: '2025', month: 'February'),
                TransactionItem(
                  img: 'education.png',
                  category: 'Education',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
                TransactionItem(
                  img: 'home.png',
                  category: 'Home',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
                TransactionItem(
                  img: 'wedding.png',
                  category: 'Wedding',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
                TransactionItem(
                  img: 'education.png',
                  category: 'Education',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
                MonthHeader(year: '2025', month: 'January'),
                TransactionItem(
                  img: 'home.png',
                  category: 'Education',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
                TransactionItem(
                  img: 'home.png',
                  category: 'Home',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
                TransactionItem(
                  img: 'education.png',
                  category: 'Education',
                  amount: '3,500.00',
                  date: '22 February 15:30 PM',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
