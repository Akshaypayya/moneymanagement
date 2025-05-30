import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class WalletDescription extends ConsumerWidget {
  const WalletDescription({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        'Manage your funds seamlessly add money to your wallet for quick transactions or withdraw it to your bank anytime. Stay in control of your balance with secure and hassle-free',
        style: TextStyle(
          fontSize: 13,
          fontFamily: GoogleFonts.poppins().fontFamily,
          color: isDark ? Colors.grey[300] : Colors.grey[800],
        ),
      ),
    );
  }
}
