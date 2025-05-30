import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class ProfileDetailItem extends ConsumerWidget {
  final String label;
  final String value;
  final Widget? suffixWidget;
  VoidCallback? onTap;
  bool isSuffixIconNeeded = false;

  ProfileDetailItem({
    Key? key,
    required this.label,
    required this.value,
    this.suffixWidget,
    required this.isSuffixIconNeeded,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    GapSpace.width6,
                    suffixWidget == null ? const SizedBox() : suffixWidget!,
                  ],
                ),
                isSuffixIconNeeded == false
                    ? const Spacer()
                    : Icon(
                        Icons.chevron_right,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
