import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/amount_option_button.dart';

class AddFundsSection extends ConsumerWidget {
  final List<Map<String, dynamic>> amountOptions;
  final int selectedAmount;
  final Function(int) onAmountSelected;
  final Function(String) onAmountChanged;
  final String amount;

  const AddFundsSection({
    Key? key,
    required this.amountOptions,
    required this.selectedAmount,
    required this.onAmountSelected,
    required this.onAmountChanged,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add funds to your wallet',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AppImages.sarSymbol,
                height: 18, color: AppColors.current(isDark).primary),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: amount)
                  ..selection = TextSelection.fromPosition(
                    TextPosition(offset: amount.length),
                  ),
                onChanged: onAmountChanged,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 1,
          color: isDark ? Colors.grey[800] : Colors.grey[300],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: amountOptions.map((option) {
            return AmountOptionButton(
              label: option['label'],
              value: option['value'],
              isSelected: selectedAmount == option['value'],
              onTap: () => onAmountSelected(option['value']),
            );
          }).toList(),
        ),
      ],
    );
  }
}
