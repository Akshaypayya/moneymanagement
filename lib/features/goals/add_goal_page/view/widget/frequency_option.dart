import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';

class FrequencyOption extends ConsumerWidget {
  final String label;
  final Widget amount;
  final bool isSelected;
  final VoidCallback? onTap;

  const FrequencyOption({
    Key? key,
    required this.label,
    required this.amount,
    required this.isSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.teal
              : isDark
                  ? Colors.black
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Colors.teal
                : isDark
                    ? Colors.grey[700]!
                    : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isSelected
                    ? Colors.white
                    : isDark
                        ? Colors.white
                        : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            amount,
          ],
        ),
      ),
    );
  }
}
