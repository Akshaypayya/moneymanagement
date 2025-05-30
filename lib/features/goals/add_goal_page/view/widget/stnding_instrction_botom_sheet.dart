import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

void showStandingInstructionBottomSheet(
    BuildContext context,
    String virtualAccount,
    double transactionAmount,
    String frequency,
    String goalName,
    {VoidCallback? onClose}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.transparent,
    builder: (context) => StandingInstructionBottomSheet(
      virtualAccount: virtualAccount,
      transactionAmount: transactionAmount,
      frequency: frequency,
      goalName: goalName,
      onClose: onClose,
    ),
  );
}

class StandingInstructionBottomSheet extends ConsumerWidget {
  final String virtualAccount;
  final double transactionAmount;
  final String frequency;
  final String goalName;
  final VoidCallback? onClose;

  const StandingInstructionBottomSheet({
    super.key,
    required this.virtualAccount,
    required this.transactionAmount,
    required this.frequency,
    required this.goalName,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Set Standing Instruction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
          GapSpace.height20,
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
              children: [
                const TextSpan(
                    text: 'Please define a standing instruction of '),
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
                    text:
                        ' from your online bank to top up your wallet for the "'),
                TextSpan(
                  text: goalName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '" gold purchase'),
              ],
            ),
          ),
          GapSpace.height20,
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Bank ID', 'Arab National Bank', isDark),
                const SizedBox(height: 5),
                _buildDetailRow('IBAN Account Number', virtualAccount, isDark),
                const SizedBox(height: 5),
                _buildDetailRow('Account Name', 'Nexus Global Limited', isDark),
              ],
            ),
          ),
          GapSpace.height20,
          Center(
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
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
