import 'package:flutter/services.dart';

class AppInputFormatters {
  /// Formatter: Only digits, max 9 characters (Saudi phone without +966)
  static List<TextInputFormatter> saudiPhoneNumber() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(9),
    ];
  }

  /// Formatter: Saudi national ID (10 digits)
  static List<TextInputFormatter> saudiNationalId() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ];
  }


  /// Formatter: Saudi ZIP code (5 digits)
  static List<TextInputFormatter> saudiZipCode() {
    return [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(5),
    ];
  }

  /// Formatter: Arabic + English names (letters and spaces)
  static List<TextInputFormatter> nameFormatter({int maxLength = 50}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\u0600-\u06FF\s]")),
      LengthLimitingTextInputFormatter(maxLength),
      CapitalizeWordsInputFormatter(),
    ];
  }

  /// Formatter: Accepts alphanumeric and common symbols for Saudi addresses
  static List<TextInputFormatter> addressFormatter({int maxLength = 100}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\u0600-\u06FF\s,.-/]")),
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }

  /// Formatter: Generic numeric-only (optionally limited)
  static List<TextInputFormatter> numericOnly({int? maxLength}) {
    return [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ];
  }



  /// Formatter: Saudi IBAN - auto SA + space every 4 chars
  static List<TextInputFormatter> saudiIbanFormatter() {
    return [
      _FormattedSaudiIbanInputFormatter(),
    ];
  }

  /// Formatter: gram formatter
  static List<TextInputFormatter> gramFormatter() {
    return [
      GramInputFormatter(),
    ];
  }
  /// Formatter: buy price formatter

  static List<TextInputFormatter> buyPriceFormatter() {
    return [
      BuyPriceFormatter(),
    ];
  }



  /// Formatter: Allows valid email characters
  static List<TextInputFormatter> emailFormatter({int maxLength = 100}) {
    return [
      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9@._\-+]")),
      LengthLimitingTextInputFormatter(maxLength),
    ];
  }
}

/// Capitalizes the first letter of each word
class CapitalizeWordsInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final text = newValue.text;
    final selection = newValue.selection;

    final capitalized = text
        .split(' ')
        .map((word) =>
    word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');

    return TextEditingValue(
      text: capitalized,
      selection: selection,
    );
  }
}

/// Converts all input to uppercase
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class _FormattedSaudiIbanInputFormatter extends TextInputFormatter {
  static const int _maxLength = 24;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final oldText = oldValue.text;
    final newText = newValue.text;
    final newSelection = newValue.selection;

    // Uppercase and remove spaces
    String raw = newText.toUpperCase().replaceAll(RegExp(r'\s+'), '');

    // Remove all non-alphanumeric characters
    final filtered = raw.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Truncate to max length
    final truncated = filtered.length > _maxLength
        ? filtered.substring(0, _maxLength)
        : filtered;

    // Adjust the cursor based on how many valid characters are before the new cursor
    int offset = newSelection.baseOffset;

    // Calculate number of valid chars before the cursor
    int validCharsBeforeCursor = 0;
    for (int i = 0; i < offset && i < newText.length; i++) {
      final char = newText[i].toUpperCase();
      if (RegExp(r'[A-Z0-9]').hasMatch(char)) {
        validCharsBeforeCursor++;
      }
    }

    // Ensure offset doesn't exceed length
    final clampedOffset = validCharsBeforeCursor.clamp(0, truncated.length);

    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: clampedOffset),
    );
  }
}
/// Formatter: Only allows up to 4-digit numeric input for grams
class GramInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    // Allow only digits and one optional decimal point
    final isValid = RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newText);
    if (!isValid) return oldValue;

    // If it contains a dot, allow up to 7 characters (e.g., 9999.99)
    if (newText.contains('.')) {
      if (newText.length > 7) return oldValue;
    } else {
      // If no dot, max length = 4 (e.g., 9999)
      if (newText.length > 4) return oldValue;
    }

    return newValue;
  }
}

class BuyPriceFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    final newText = newValue.text;

    // Allow only digits and optional one decimal point with up to 2 digits after it
    final isValid = RegExp(r'^\d*\.?\d{0,2}$').hasMatch(newText);
    if (!isValid) return oldValue;

    if (newText.contains('.')) {
      // If decimal exists, limit length to 15
      if (newText.length > 15) return oldValue;
    } else {
      // If no decimal, limit length to 12
      if (newText.length > 12) return oldValue;
    }

    return newValue;
  }
}
