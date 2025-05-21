import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';

class ProfileNavigationItem extends ConsumerWidget {
  final String label;
  final String value1;
  final String? value2;
  final String? value3;
  final VoidCallback onTap;
  final bool isValue2Needed;
  final bool isValue3Needed;

  const ProfileNavigationItem({
    Key? key,
    required this.label,
    required this.value1,
    this.value2,
    this.value3,
    required this.onTap,
    this.isValue2Needed = false,
    this.isValue3Needed = false,
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value1,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    isValue2Needed == true
                        ? Text(
                            value2!,
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          )
                        : const SizedBox(),
                    isValue3Needed == true
                        ? Text(
                            value3!,
                            style: TextStyle(
                              fontFamily: GoogleFonts.poppins().fontFamily,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                Icon(
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
