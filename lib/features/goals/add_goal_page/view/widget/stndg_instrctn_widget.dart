import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/detail_row_stndng_instrn.dart';

Widget stndgInstrctnTitle(bool isDark) {
  return Center(
    child: Text(
      'Set Standing Instruction',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: isDark ? Colors.white : Colors.black,
      ),
    ),
  );
}

Container stndgInstrctnContainer(bool isDark, String virtualAccount) {
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
        detailRowStndngInstrc('Bank ID', 'Arab National Bank', isDark),
        const SizedBox(height: 5),
        detailRowStndngInstrc('IBAN Account Number', virtualAccount, isDark),
        const SizedBox(height: 5),
        detailRowStndngInstrc('Account Name', 'Nexus Global Limited', isDark),
      ],
    ),
  );
}

Widget closeStngInstrctn(
    BuildContext context, final VoidCallback? onClose, bool isDark) {
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
          'Close',
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

Widget sngInstrctnTextSpan(
    bool isDark, double transactionAmount, String frequency, String goalName) {
  return RichText(
    text: TextSpan(
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: GoogleFonts.poppins().fontFamily,
        color: isDark ? Colors.grey[300] : Colors.grey[700],
        height: 1.5,
      ),
      children: [
        const TextSpan(text: 'Please define a standing instruction of '),
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
        const TextSpan(text: ' amount in each '),
        TextSpan(
          text: frequency,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const TextSpan(
            text: ' from your online bank to top up your wallet for the "'),
        TextSpan(
          text: goalName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const TextSpan(text: '" gold purchase'),
      ],
    ),
  );
}
