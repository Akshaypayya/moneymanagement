import 'package:growk_v2/views.dart';

Column goalItemRow2(
  String currentGold,
  String invested,
  String target,
  String progress,
  double progressPercent,
  String goalStatus,
  bool isDark,
  WidgetRef ref,
) {
  final texts = ref.watch(appTextsProvider);
  return Column(
    children: [
      Row(
        children: [
          Text(
            texts.currentGoldHoldings,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: goalStatus == "COMPLETED"
                  ? Colors.black
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          Text(
            currentGold,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: goalStatus == "COMPLETED"
                  ? Colors.black
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                texts.invested,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: goalStatus == "COMPLETED"
                      ? Colors.black
                      : isDark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              Image.asset(
                AppImages.sarSymbol,
                height: 13,
                // color: AppColors.current(isDark).primary,
                color: goalStatus == "COMPLETED"
                    ? Colors.black
                    : AppColors.current(isDark).primary,
              ),
              Text(
                ' $invested',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: goalStatus == "COMPLETED"
                      ? Colors.black
                      : isDark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                texts.target,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: goalStatus == "COMPLETED"
                      ? Colors.black
                      : isDark
                          ? Colors.white
                          : Colors.black,
                ),
              ),
              Image.asset(
                AppImages.sarSymbol,
                height: 13,
                color: goalStatus == "COMPLETED"
                    ? Colors.black
                    : AppColors.current(isDark).primary,
              ),
              Text(
                ' $target',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: goalStatus == "COMPLETED"
                      ? Colors.black
                      : isDark
                          ? Colors.white
                          : Colors.black,
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
          backgroundColor:
              goalStatus == "COMPLETED" ? Colors.white : Colors.grey[300],
          // backgroundColor: goalStatus == "COMPLETED"
          //     ? Colors.black
          //     : isDark
          //         ? Colors.white
          //         : Colors.black,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            texts.progress,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: goalStatus == "COMPLETED"
                  ? Colors.black
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          Text(
            progress,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: goalStatus == "COMPLETED"
                  ? Colors.black
                  : isDark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
        ],
      ),
    ],
  );
}
