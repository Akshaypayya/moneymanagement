// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:growk_v2/core/constants/app_images.dart';
// import 'package:growk_v2/core/theme/app_theme.dart';
// import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
// import 'package:growk_v2/features/goals/add_goal_page/view/widget/custom_slider.dart';

// class SavingsAmountSlider extends ConsumerStatefulWidget {
//   const SavingsAmountSlider({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _SavingsAmountSliderState();
// }

// class _SavingsAmountSliderState extends ConsumerState<SavingsAmountSlider> {
//   late TextEditingController _controller;
//   bool _isUpdatingFromSlider = false;
//   bool _isUpdatingFromTextField = false;

//   final double minAmount = 10000.0;
//   final double maxAmount = 1000000.0;
//   final double stepSize = 10000.0;

//   @override
//   void initState() {
//     super.initState();

//     final initialAmount = ref.read(calculatedAmountProvider);
//     _controller =
//         TextEditingController(text: _formatNumber(initialAmount.round()));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

// String _formatNumber(int number) {
//   final String numStr = number.toString();
//   final StringBuffer result = StringBuffer();
//   int count = 0;

//   for (int i = numStr.length - 1; i >= 0; i--) {
//     count++;
//     result.write(numStr[i]);
//     if (count % 3 == 0 && i > 0) {
//       result.write(',');
//     }
//   }

//   return result.toString().split('').reversed.join('');
// }

// int _parseNumber(String formattedNumber) {
//   final cleanedString = formattedNumber.replaceAll(RegExp(r'[^0-9]'), '');
//   if (cleanedString.isEmpty) return minAmount.round();

//   final parsedInt = int.tryParse(cleanedString);
//   if (parsedInt == null) return minAmount.round();

//   final clampedValue = parsedInt.clamp(minAmount.round(), maxAmount.round());
//   final roundedValue = ((clampedValue / stepSize).round() * stepSize).toInt();

//   return roundedValue;
// }

// void _updateSliderFromTextField(String text) {
//   if (_isUpdatingFromSlider) return;

//   _isUpdatingFromTextField = true;
//   try {
//     final parsedValue = _parseNumber(text);

//     final sliderPosition =
//         (parsedValue - minAmount) / (maxAmount - minAmount);

//     ref.read(amountSliderProvider.notifier).state = sliderPosition;

//     final formattedValue = _formatNumber(parsedValue);
//     if (_controller.text != formattedValue) {
//       final oldSelection = _controller.selection;

//       _controller.text = formattedValue;

//       if (oldSelection.extentOffset > 0) {
//         final lengthDiff = formattedValue.length - text.length;
//         final newPosition = oldSelection.extentOffset + lengthDiff;
//         if (newPosition >= 0 && newPosition <= formattedValue.length) {
//           _controller.selection = TextSelection.fromPosition(
//             TextPosition(offset: newPosition),
//           );
//         } else {
//           _controller.selection = TextSelection.fromPosition(
//             TextPosition(offset: formattedValue.length),
//           );
//         }
//       }
//     }
//   } finally {
//     _isUpdatingFromTextField = false;
//   }
// }

// void _updateTextFieldFromSlider(double amount) {
//   if (_isUpdatingFromTextField) return;

//   _isUpdatingFromSlider = true;
//   try {
//     final roundedAmount = ((amount / stepSize).round() * stepSize).toInt();

//     final formattedAmount = _formatNumber(roundedAmount);

//     if (_controller.text != formattedAmount) {
//       final oldCursorPosition = _controller.selection.extentOffset;
//       final oldTextLength = _controller.text.length;

//       _controller.text = formattedAmount;

//       final newTextLength = formattedAmount.length;
//       final newCursorPosition =
//           oldCursorPosition + (newTextLength - oldTextLength);

//       if (newCursorPosition >= 0 && newCursorPosition <= newTextLength) {
//         _controller.selection = TextSelection.fromPosition(
//           TextPosition(offset: newCursorPosition),
//         );
//       } else {
//         _controller.selection = TextSelection.fromPosition(
//           TextPosition(offset: newTextLength),
//         );
//       }
//     }
//   } finally {
//     _isUpdatingFromSlider = false;
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = ref.watch(isDarkProvider);
//     final amountValue = ref.watch(amountSliderProvider);
//     final calculatedAmount = ref.watch(calculatedAmountProvider);

//     if (!_isUpdatingFromTextField && !_isUpdatingFromSlider) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         _updateTextFieldFromSlider(calculatedAmount);
//       });
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Set Your Savings Goal',
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//             fontFamily: GoogleFonts.poppins().fontFamily,
//             color: isDark ? Colors.white : Colors.black,
//           ),
//         ),
//         const SizedBox(height: 15),
//         Row(
//           children: [
//             Text(
//               '10K',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: CustomSlider(
//                   value: amountValue,
//                   activeColor: Colors.teal,
//                   stateProvider: amountSliderProvider,
//                   isSteppedAmount: true,
//                 ),
//               ),
//             ),
//             Text(
//               '1M',
//               style: TextStyle(
//                 fontSize: 13,
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//             ),
//           ],
//         ),
//         Align(
//           alignment: Alignment.centerRight,
//           child: Padding(
//             padding: const EdgeInsets.only(top: 5.0),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Target Amount: ',
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: GoogleFonts.poppins().fontFamily,
//                     color: isDark ? Colors.white : Colors.black,
//                   ),
//                 ),
//                 Image.asset(
//                   AppImages.sarSymbol,
//                   height: 13,
//                   color: AppColors.current(isDark).primary,
//                 ),
//                 SizedBox(
//                   // color: Colors.red,
//                   width: 75,
//                   child: Transform.translate(
//                     offset: const Offset(0, -8),
//                     child: TextFormField(
//                         // initialValue: formattedAmount,
//                         controller: _controller,
//                         keyboardType: TextInputType.number,
//                         style: TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: GoogleFonts.poppins().fontFamily,
//                           color: isDark ? Colors.white : Colors.black,
//                         ),
//                         cursorColor: isDark ? Colors.white : Colors.black,
//                         decoration: InputDecoration(
//                             focusedBorder: UnderlineInputBorder(
//                               borderSide: BorderSide(
//                                   color: isDark ? Colors.white : Colors.black),
//                             ),
//                             contentPadding:
//                                 const EdgeInsets.fromLTRB(3, 10, 0, -10))),
//                   ),
//                 ),
// SizedBox(
//   width: 120,
//   child: Transform.translate(
//     offset: const Offset(0, -8),
//     child: TextField(
//       controller: _controller,
//       keyboardType: TextInputType.number,
//       textAlign: TextAlign.start,
//       onChanged: _updateSliderFromTextField,
//       style: TextStyle(
//         fontSize: 13,
//         fontWeight: FontWeight.bold,
//         fontFamily: GoogleFonts.poppins().fontFamily,
//         color: isDark ? Colors.white : Colors.black,
//       ),
//       cursorColor: isDark ? Colors.white : Colors.black,
//       inputFormatters: [
//         FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
//       ],
//       decoration: InputDecoration(
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: isDark ? Colors.white : Colors.black,
//           ),
//         ),
//         contentPadding:
//             const EdgeInsets.fromLTRB(3, 10, 0, -10),
//       ),
//     ),
//   ),
// ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/view/widget/custom_slider_wrapper.dart';

class SavingsAmountSlider extends ConsumerStatefulWidget {
  const SavingsAmountSlider({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SavingsAmountSliderState();
}

class _SavingsAmountSliderState extends ConsumerState<SavingsAmountSlider> {
  late TextEditingController _controller;
  bool _isUpdatingFromSlider = false;
  bool _isUpdatingFromTextField = false;

  final double minAmount = 10000.0;
  final double maxAmount = 1000000.0;
  final double stepSize = 10000.0;

  @override
  void initState() {
    super.initState();
    final initialAmount = ref.read(calculatedAmountProvider);
    _controller =
        TextEditingController(text: _formatNumber(initialAmount.round()));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    final String numStr = number.toString();
    final StringBuffer result = StringBuffer();
    int count = 0;

    for (int i = numStr.length - 1; i >= 0; i--) {
      count++;
      result.write(numStr[i]);
      if (count % 3 == 0 && i > 0) {
        result.write(',');
      }
    }

    return result.toString().split('').reversed.join('');
  }

  int _parseNumber(String formattedNumber) {
    final cleanedString = formattedNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanedString.isEmpty) return minAmount.round();

    final parsedInt = int.tryParse(cleanedString);
    if (parsedInt == null) return minAmount.round();

    final clampedValue = parsedInt.clamp(minAmount.round(), maxAmount.round());
    final roundedValue = ((clampedValue / stepSize).round() * stepSize).toInt();

    return roundedValue;
  }

  void _updateSliderFromTextField(String text) {
    if (_isUpdatingFromSlider) return;

    _isUpdatingFromTextField = true;
    try {
      final parsedValue = _parseNumber(text);

      final sliderPosition =
          (parsedValue - minAmount) / (maxAmount - minAmount);

      ref.read(amountSliderProvider.notifier).state = sliderPosition;

      final formattedValue = _formatNumber(parsedValue);
      if (_controller.text != formattedValue) {
        final oldSelection = _controller.selection;

        _controller.text = formattedValue;

        if (oldSelection.extentOffset > 0) {
          final lengthDiff = formattedValue.length - text.length;
          final newPosition = oldSelection.extentOffset + lengthDiff;
          if (newPosition >= 0 && newPosition <= formattedValue.length) {
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: newPosition),
            );
          } else {
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: formattedValue.length),
            );
          }
        }
      }
    } finally {
      _isUpdatingFromTextField = false;
    }
  }

  void _updateTextFieldFromSlider(double amount) {
    if (_isUpdatingFromTextField) return;

    _isUpdatingFromSlider = true;
    try {
      final roundedAmount = ((amount / stepSize).round() * stepSize).toInt();

      final formattedAmount = _formatNumber(roundedAmount);

      if (_controller.text != formattedAmount) {
        final oldCursorPosition = _controller.selection.extentOffset;
        final oldTextLength = _controller.text.length;

        _controller.text = formattedAmount;

        final newTextLength = formattedAmount.length;
        final newCursorPosition =
            oldCursorPosition + (newTextLength - oldTextLength);

        if (newCursorPosition >= 0 && newCursorPosition <= newTextLength) {
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newCursorPosition),
          );
        } else {
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newTextLength),
          );
        }
      }
    } finally {
      _isUpdatingFromSlider = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final amountValue = ref.watch(amountSliderProvider);
    final calculatedAmount = ref.watch(calculatedAmountProvider);

    if (!_isUpdatingFromTextField && !_isUpdatingFromSlider) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updateTextFieldFromSlider(calculatedAmount);
      });
    }

    final amountDisplay = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Target Amount: ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        Image.asset(
          AppImages.sarSymbol,
          height: 13,
          color: AppColors.current(isDark).primary,
        ),
        SizedBox(
          width: 120,
          child: Transform.translate(
            offset: const Offset(0, -8),
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.start,
              onChanged: _updateSliderFromTextField,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
              cursorColor: isDark ? Colors.white : Colors.black,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
              ],
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(3, 10, 0, -10),
              ),
            ),
          ),
        ),
      ],
    );

    return CustomSliderWrapper(
      title: 'Set Your Savings Goal',
      leftLabel: '10K',
      rightLabel: '1M',
      value: amountValue,
      stateProvider: amountSliderProvider,
      valueDisplay: amountDisplay,
      isSteppedAmount: true,
    );
  }
}
