import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

import '../../../views.dart';

class WalletStandingInstruction extends ConsumerWidget {
  final String bankId;
  final String ibanAccount;
  final String accountName;

  const WalletStandingInstruction({
    super.key,
    required this.bankId,
    required this.ibanAccount,
    required this.accountName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.grey[300] : Colors.grey[700];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top-up via Bank Transfer',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: textColor,
          ),
        ),
        GapSpace.height16,
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: subTextColor,
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            children: const [
              TextSpan(text: 'Please send the transfer from your online bank to top up your wallet'),
              // TextSpan(text: '"x"', style: TextStyle(fontWeight: FontWeight.bold)),
              // TextSpan(text: ' amount in each '),
              // TextSpan(text: '"Monthly"', style: TextStyle(fontWeight: FontWeight.bold)),
              // TextSpan(text: ' from your online bank to top up your wallet for the '),
              // TextSpan(text: '"Goal"', style: TextStyle(fontWeight: FontWeight.bold)),
              // TextSpan(text: ' gold purchase'),
            ],
          ),
        ),
        GapSpace.height20,
        _buildRow('Bank ID', bankId, isDark),
        GapSpace.height10,
        _buildRow('IBAN Account number', ibanAccount, isDark),
        GapSpace.height10,
        _buildRow('Account name', accountName, isDark),
        GapSpace.height24,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: Icon(Icons.copy, color: textColor),
              onPressed: () {
                final text = 'Bank ID: $bankId\nIBAN: $ibanAccount\nAccount: $accountName';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Standing instruction copied')),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.share, color: textColor),
              onPressed: () {
                final text = 'Bank ID: $bankId\nIBAN: $ibanAccount\nAccount: $accountName';
                Share.share(text);
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyle().bodySmall.copyWith(color: isDark ? Colors.grey[400] : Colors.grey[700])
          ),
        ),
        const Text(" : "),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: AppTextStyle().titleSmall
          ),
        ),
      ],
    );
  }
}
