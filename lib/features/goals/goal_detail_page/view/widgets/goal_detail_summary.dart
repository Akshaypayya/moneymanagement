import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/core/theme/app_text_styles.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/reusable_text.dart';

class GoalSummary extends ConsumerWidget {
  final String amount;
  final String profit;
  final String currentGold;
  final String virtualAccountNbr;
  final String currentGoldPrice;
  final String invested;

  const GoalSummary({
    Key? key,
    required this.amount,
    required this.profit,
    required this.currentGold,
    required this.virtualAccountNbr,
    required this.currentGoldPrice,
    required this.invested,
  }) : super(key: key);

  @override
  double getProfitVal(String amount, String invested) {
    double val1 = double.tryParse(amount) ?? 0;
    double val2 = double.tryParse(invested) ?? 0;
    double profitVal = val1 - val2;
    // this.profitVal = profitVal.toString();
    debugPrint("profit value : $profitVal");
    return profitVal;
  }

  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.sarSymbol,
                height: 20,
                color: AppColors.current(isDark).primary,
              ),
              const SizedBox(width: 5),
              ReusableText(
                text: '$amount',
                style: AppTextStyle(textColor: textColor).titleMedium,
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Text(
                    '(Profit: ',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Image.asset(
                    AppImages.sarSymbol,
                    height: 13,
                    color: getProfitVal(amount, invested) < 0
                        ? Colors.red
                        : Colors.green,
                  ),
                  getProfitVal(amount, invested) < 0
                      ? GapSpace.width5
                      : const SizedBox(),
                  Text(
                    getProfitVal(amount, invested).toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: getProfitVal(amount, invested) < 0
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  Text(
                    ')',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Gold Holdings: ',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              Text(
                '$currentGold',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              GapSpace.width5,
              Row(
                children: [
                  Text(
                    '(',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Image.asset(
                    AppImages.sarSymbol,
                    height: 13,
                  ),
                  GapSpace.width5,
                  Text(
                    '$currentGoldPrice)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Virtual Account: ',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[800],
                ),
              ),
              Text(
                virtualAccountNbr,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
