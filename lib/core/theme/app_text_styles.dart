import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/views.dart';

class AppTextStyle {
  final Color textColor;

  const AppTextStyle({required this.textColor});

  TextStyle get headlineLarge => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textColor,
      );
  TextStyle get headlineVeryLarge => GoogleFonts.poppins(
        fontSize: 42,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  TextStyle get titleMedium => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
  TextStyle get titleRegular => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
  TextStyle get titleSmall => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
  TextStyle get titleBottomNav => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: textColor,
      );
  TextStyle get titleSmallMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textColor,
      );
  TextStyle get titleRegularMedium => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textColor,
      );
  TextStyle get bodyMedium => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textColor,
      );
  TextStyle get bodyRegular => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      );
  TextStyle get labelRegular => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textColor,
      );

  TextStyle get labelSmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textColor.withOpacity(0.8),
      );
  TextStyle get bodySmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor.withOpacity(0.8),
      );
  TextStyle get bodyKycSmall => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor.withOpacity(0.8),
      );
  TextStyle get titleLrg => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      );

  /// Accessor: AppTextStyle.current(isDark).bodyRegular
  static AppTextStyle current(bool isDark) =>
      AppTextStyle(textColor: AppColors.current(isDark).text);
}
