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
                'Saving for',
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              ReusableText(
                text: title,
                style: AppTextStyle(textColor: textColor).titleMedium,
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
                  height: 16, color: AppColors.current(isDark).primary),
              const SizedBox(width: 3),
              ReusableText(
                text: amount,
                style: AppTextStyle(textColor: textColor).titleRegular,
              ),
            ],
          ),
          goalStatus == "COMPLETED"
              ? const SizedBox()
              : ReusableRow(
                  children: [
                    ReusableText(
                      text: '(Profit: ',
                      style: AppTextStyle(textColor: textColor).bodyRegular,
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
                      style: AppTextStyle(textColor: textColor).bodyRegular,
                    ),
                  ],
                )
        ],
      ),
    ],
  );
}
