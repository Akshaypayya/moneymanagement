import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/custom_slider.dart';

class CustomSliderWrapper extends ConsumerWidget {
  final String title;
  final String leftLabel;
  final String rightLabel;
  final double value;
  final StateProvider<double> stateProvider;
  final Widget? valueDisplay;
  final Color activeColor;
  final bool isSteppedAmount;

  const CustomSliderWrapper({
    Key? key,
    required this.title,
    required this.leftLabel,
    required this.rightLabel,
    required this.value,
    required this.stateProvider,
    this.valueDisplay,
    this.activeColor = Colors.teal,
    this.isSteppedAmount = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                leftLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: CustomSlider(
                  value: value,
                  activeColor: activeColor,
                  stateProvider: stateProvider,
                  isSteppedAmount: isSteppedAmount,
                ),
              ),
            ),
            SizedBox(
              width: 30,
              child: Text(
                rightLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
        if (valueDisplay != null)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: valueDisplay!,
            ),
          ),
      ],
    );
  }
}
