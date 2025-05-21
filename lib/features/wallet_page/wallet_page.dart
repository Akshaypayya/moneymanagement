import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/core/widgets/growk_button.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/add_funds_section.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/bank_selection.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/wallet_confirm_button.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/wallet_description.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/wallet_header.dart';

final selectedAmountProvider = StateProvider<int>((ref) => 1001);

final amountTextProvider = StateProvider<String>((ref) => "1,001");

class WalletPage extends ConsumerWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final selectedAmount = ref.watch(selectedAmountProvider);

    final walletData = {
      'balance': '1,547.81',
      'bankName': 'Saudi Awwal Bank',
      'accountNumber': '************5478',
    };

    final amountOptions = [
      {'value': 101, 'label': 'SAR 101'},
      {'value': 501, 'label': 'SAR 501'},
      {'value': 1001, 'label': 'SAR 1,001'},
    ];

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: GrowkAppBar(title: 'Wallet', isBackBtnNeeded: true),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletHeader(
                  balance: walletData['balance']!,
                ),
                const WalletDescription(),
                const SizedBox(height: 20),
                AddFundsSection(
                  amountOptions: amountOptions,
                  selectedAmount: selectedAmount,
                  onAmountSelected: (value) {
                    ref.read(selectedAmountProvider.notifier).state = value;

                    final formattedAmount = value.toString().replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match match) => '${match[1]},');

                    ref.read(amountTextProvider.notifier).state =
                        formattedAmount;
                  },
                  onAmountChanged: (value) {
                    ref.read(amountTextProvider.notifier).state = value;

                    final parsedValue =
                        int.tryParse(value.replaceAll(',', '')) ?? 0;

                    ref.read(selectedAmountProvider.notifier).state =
                        parsedValue;
                  },
                  amount: ref.watch(amountTextProvider),
                ),
                const SizedBox(height: 30),
                BankSelection(
                  bankName: walletData['bankName']!,
                  accountNumber: walletData['accountNumber']!,
                ),
                const Spacer(),
                const GrowkButton(
                    title: 'Confirm & Add'), //WalletConfirmButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
