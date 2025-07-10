import 'package:growk_v2/features/goals/add_goal_page/view/widget/detail_row_stndng_instrn.dart';
import 'package:growk_v2/views.dart';

Widget stndgInstrctnTitle(bool isDark, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Center(
    child: Text(
      texts.setStandingInstruction,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: isDark ? Colors.white : Colors.black,
      ),
    ),
  );
}

Container stndgInstrctnContainer(
    bool isDark, String virtualAccount, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
        width: 1,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        detailRowStndngInstrc(texts.bankID, texts.arabNationalBank, isDark),
        const SizedBox(height: 5),
        detailRowStndngInstrc(
            texts.iBANAccountNumberID, virtualAccount, isDark),
        const SizedBox(height: 5),
        detailRowStndngInstrc(
            texts.accountName, texts.nexusGlobalLimited, isDark),
      ],
    ),
  );
}

Widget closeStngInstrctn(BuildContext context, final VoidCallback? onClose,
    bool isDark, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Center(
    child: SizedBox(
      height: 45,
      width: 250,
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (onClose != null) {
            onClose!();
          } else {
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: Text(
          texts.close,
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
  );
}

Widget sngInstrctnTextSpan(bool isDark, double transactionAmount,
    String frequency, String goalName, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return RichText(
    text: TextSpan(
      style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.grey[300] : Colors.grey[700],
          height: 1.5),
      children: [
        TextSpan(text: texts.plsDefineStndInst),
        WidgetSpan(
          child: Image.asset(
            AppImages.sarSymbol,
            height: 13,
            color: AppColors.current(isDark).primary,
          ),
          alignment: PlaceholderAlignment.middle,
        ),
        TextSpan(
          text: ' ${transactionAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: texts.amountInEach),
        TextSpan(
          text: frequency,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: texts.bnkToWalet),
        TextSpan(
          text: goalName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(text: texts.goldpurchase),
      ],
    ),
  );
}
