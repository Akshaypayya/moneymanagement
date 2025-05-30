import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class WalletHeader extends ConsumerWidget {
  final String balance;

  const WalletHeader({
    Key? key,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Wallet Balance',
          style: TextStyle(
            fontSize: 13,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.grey[400] : Colors.grey[700],
          ),
        ),
        GapSpace.height5,
        Row(
          children: [
            Image.asset(
              AppImages.sarSymbol,
              height: 18,
              color: AppColors.current(isDark).primary,
            ),
            const SizedBox(width: 4),
            Text(
              balance,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        GapSpace.height10,
        GestureDetector(
          onTap: () {},
          child: Text(
            'Withdraw to Bank',
            style: TextStyle(
              fontSize: 16,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: Colors.blue[600],
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }
}
