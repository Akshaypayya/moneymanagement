import 'package:growk_v2/views.dart';

Row goalItemDataRow(
  WidgetRef ref,
  Widget iconWidget,
  String? iconAsset,
  String title,
  String amount,
  String invested,
  String goalStatus,
  Color textColor,
) {
  final isDark = ref.watch(isDarkProvider);
  final texts = ref.watch(appTextsProvider);

  double getProfitVal(String amount, String invested) {
    double val1 = double.tryParse(amount) ?? 0;
    double val2 = double.tryParse(invested) ?? 0;
    double profitVal = val1 - val2;
    debugPrint("profit value : $profitVal");
    return profitVal;
  }

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? (Colors.grey[800] ?? Colors.grey)
                    : (Colors.grey[400] ?? Colors.grey),
                width: 1,
              ),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: iconWidget != null
                  ? SizedBox(
                      width: 90,
                      height: 90,
                      child: iconWidget!,
                    )
                  : iconAsset != null && iconAsset!.isNotEmpty
                      ? ClipOval(
                          child: Image.asset(
                            iconAsset!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.scaleDown,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/customgoals.jpg',
                                width: 90,
                                height: 90,
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        )
                      : ClipOval(
                          child: Image.asset(
                            'assets/customgoals.jpg',
                            width: 90,
                            height: 90,
                            fit: BoxFit.contain,
                          ),
                        ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texts.savingfor,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: goalStatus == "COMPLETED"
                      ? Colors.black
                      : isDark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              SizedBox(
                width: 170,
                child: ReusableText(
                  text: title,
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: goalStatus == "COMPLETED"
                        ? Colors.black
                        : isDark
                            ? Colors.white
                            : Colors.black,
                  ),
                  //  AppTextStyle(textColor: textColor).titleMedium,
                ),
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
              Image.asset(
                AppImages.sarSymbol,
                height: 16,
                // color: AppColors.current(isDark).primary
                color: goalStatus == "COMPLETED"
                    ? Colors.black
                    : AppColors.current(isDark).primary,
              ),
              const SizedBox(width: 3),
              ReusableText(
                text: amount,
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: goalStatus == "COMPLETED"
                      ? Colors.black
                      : isDark
                          ? Colors.white
                          : Colors.black,
                ),
                // AppTextStyle(textColor: textColor).titleRegular,
              ),
            ],
          ),
          goalStatus == "COMPLETED"
              ? const SizedBox()
              : ReusableRow(
                  children: [
                    ReusableText(
                      text: '(${texts.profit}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: goalStatus == "COMPLETED"
                            ? Colors.black
                            : isDark
                                ? Colors.white
                                : Colors.black,
                      ),
                      // AppTextStyle(textColor: textColor).bodyRegular,
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
                      text: getProfitVal(amount, invested).toStringAsFixed(2),
                      style: AppTextStyle(
                        textColor: getProfitVal(amount, invested) < 0
                            ? Colors.red
                            : Colors.green,
                      ).titleSmall,
                    ),
                    ReusableText(
                      text: ')',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                        color: goalStatus == "COMPLETED"
                            ? Colors.black
                            : isDark
                                ? Colors.white
                                : Colors.black,
                      ),
                      //  AppTextStyle(textColor: textColor).bodyRegular,
                    ),
                  ],
                )
        ],
      ),
    ],
  );
}
