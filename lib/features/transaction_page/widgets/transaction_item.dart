import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_text_styles.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/reusable_row.dart';
import 'package:money_mangmnt/core/widgets/reusable_sized_box.dart';
import 'package:money_mangmnt/core/widgets/reusable_text.dart';

class TransactionItem extends ConsumerWidget {
  final String img;
  final String category;
  final String amount;
  final String date;

  const TransactionItem({
    Key? key,
    required this.img,
    required this.category,
    required this.amount,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        // color: Colors.red,
        border: Border(
          bottom: BorderSide(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
              // color: AppColors.current(!isDark).background,
              width: 1),
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
                  // color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                  color: AppColors.current(!isDark).background),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Image.asset(
                "assets/$img",
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: category,
                  style: AppTextStyle(textColor: textColor).titleRegular,
                ),
                const SizedBox(height: 4),
                Text(
                  'The amount is auto-debited from your account and added to your Gold savings.',
                  style: TextStyle(
                    fontSize: 12,
                    // color: isDark ? Colors.grey.shade400 : Colors.grey.shade900,
                    color: AppColors.current(isDark).text,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                ReusableText(
                  text: date,
                  style: AppTextStyle(
                          textColor: isDark
                              ? Colors.grey.shade500
                              : Colors.grey.shade400)
                      .labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.translate(
            offset: Offset(0, 36),
            child: ReusableRow(
              children: [
                Image.asset(AppImages.sarSymbol,
                    height: 16, color: AppColors.current(isDark).primary),
                ReusableSizedBox(
                  width: 3,
                ),
                ReusableText(
                  text: amount,
                  style: AppTextStyle(textColor: textColor).titleRegular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
