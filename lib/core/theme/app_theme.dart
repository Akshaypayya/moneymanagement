import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isDarkProvider = StateProvider<bool>((ref) => false);

class AppColors {
  final Color background;
  final Color text;
  final Color labelText;
  final Color dividerColor;
  final Color primary;
  final Color resendBlue;
  final Color scaffoldBackground;

  const AppColors({
    required this.background,
    required this.text,
    required this.primary,
    required this.labelText,
    required this.dividerColor,
    required this.resendBlue,
    required this.scaffoldBackground,
  });

  static AppColors light = AppColors(
    scaffoldBackground: Color.fromRGBO(246, 240, 240, 1),
    resendBlue: Color.fromRGBO(58, 89, 185, 1),
    dividerColor: Color.fromRGBO(185, 185, 185, 1),
    labelText: Colors.grey[500]!,
    background: Colors.white,
    text: Colors.black,
    primary: Colors.black,
  );

  static AppColors dark = AppColors(
    resendBlue: Color.fromRGBO(58, 89, 185, 1),
    scaffoldBackground: Color(0xFF1C1C1C),
    dividerColor: Color.fromRGBO(185, 185, 185, 1),
    labelText: Colors.grey[500]!,
    background: Colors.black,
    text: Colors.white,
    primary: Colors.white,
  );

  static AppColors current(bool isDark) => isDark ? dark : light;
}

// ✅ Utility to detect and update system theme state
void detectAndSetSystemTheme(BuildContext context, WidgetRef ref) {
  final brightness = MediaQuery.of(context).platformBrightness;
  final isDark = brightness == Brightness.dark;
  ref.read(isDarkProvider.notifier).state = isDark;
}
