import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_text_styles.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/reusable_row.dart';
import 'package:money_mangmnt/core/widgets/reusable_sized_box.dart';
import 'package:money_mangmnt/core/widgets/reusable_text.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/goal_detail_page.dart';

class GoalItem extends ConsumerWidget {
  final String? iconAsset;
  final String title;
  final String amount;
  final String profit;
  final String currentGold;
  final String invested;
  final String target;
  final String progress;
  final double progressPercent;
  final bool isLast;
  final Widget? iconWidget;

  GoalItem({
    Key? key,
    this.iconAsset,
    required this.title,
    required this.amount,
    required this.profit,
    required this.currentGold,
    required this.invested,
    required this.target,
    required this.progress,
    required this.progressPercent,
    this.isLast = false,
    this.iconWidget,
  }) : super(key: key);

  // String profitVal = '';

  double getProfitVal(String amount, String invested) {
    double val1 = double.tryParse(amount) ?? 0;
    double val2 = double.tryParse(invested) ?? 0;
    double profitVal = val1 - val2;
    // this.profitVal = profitVal.toString();
    debugPrint("profit value : $profitVal");
    return profitVal;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetailPage(
              goalName: title,
              goalIcon: iconAsset,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.black : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        iconWidget ??
                            Image.asset(
                              iconAsset!,
                              width: 35,
                              height: 35,
                            ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saving for',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                              ),
                            ),
                            ReusableText(
                              text: title,
                              style: AppTextStyle(textColor: textColor)
                                  .titleMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Image.asset(AppImages.sarSymbol,
                                height: 16,
                                color: AppColors.current(isDark).primary),
                            const SizedBox(width: 3),
                            ReusableText(
                              text: amount,
                              style: AppTextStyle(textColor: textColor)
                                  .titleRegular,
                            ),
                          ],
                        ),
                        ReusableRow(
                          children: [
                            ReusableText(
                              text: '(Profit: ',
                              style: AppTextStyle(textColor: textColor)
                                  .bodyRegular,
                            ),
                            Image.asset(
                              AppImages.sarSymbol,
                              height: 13,
                              color: getProfitVal(amount, invested) < 0
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            ReusableSizedBox(
                              width: 3,
                            ),
                            ReusableText(
                              text: getProfitVal(amount, invested)
                                  .toStringAsFixed(2),
                              style: AppTextStyle(
                                textColor: getProfitVal(amount, invested) < 0
                                    ? Colors.red
                                    : Colors.green,
                              ).titleSmall,
                            ),
                            ReusableText(
                              text: ')',
                              style: AppTextStyle(textColor: textColor)
                                  .bodyRegular,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Text(
                      'Current Gold Holdings: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                    Text(
                      currentGold,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.grey[300] : Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Invested Amount: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                        Image.asset(AppImages.sarSymbol,
                            height: 13,
                            color: AppColors.current(isDark).primary),
                        const SizedBox(width: 3),
                        Text(
                          invested,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Target: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                        Image.asset(AppImages.sarSymbol,
                            height: 13,
                            color: AppColors.current(isDark).primary),
                        const SizedBox(width: 3),
                        Text(
                          target,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progressPercent,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.teal),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Progress: ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      progress,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: AppColors.current(isDark).scaffoldBackground,
            height: 10,
          ),
        ],
      ),
    );
  }
}
