import 'package:money_mangmnt/features/wallet_page/provider/wallet_screen_providers.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/add_funds_section.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/wallet_description.dart';
import 'package:money_mangmnt/features/wallet_page/widgets/wallet_header.dart';

import '../../views.dart';

final selectedAmountProvider = StateProvider<int>((ref) => 1001);
final amountTextProvider = StateProvider<String>((ref) => "1,001");
final showWalletBalanceProvider = StateProvider<String>((ref) => "");

class WalletPage extends ConsumerStatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  ConsumerState<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends ConsumerState<WalletPage> {
  @override
  void initState() {
    super.initState();
    // Trigger the wallet balance API once on init
    Future.microtask(() {
      ref.read(getNewWalletBalanceProvider);
      ref.read(userProfileControllerProvider).refreshUserProfile(ref);
      ref.read(selectedAmountProvider.notifier).state = 1001;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final selectedAmount = ref.watch(selectedAmountProvider);

    final amountOptions = [
      {'value': 101, 'label': 'SAR 101'},
      {'value': 501, 'label': 'SAR 501'},
      {'value': 1001, 'label': 'SAR 1,001'},
    ];

    final walletAsync = ref.watch(getNewWalletBalanceProvider);
    final notifier = ref.read(loadWalletAmountNotifierProvider.notifier);

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
                walletAsync.when(
                  data: (walletData) => WalletHeader(
                      balance: "${walletData.data?.walletBalance ?? 0.0}"),
                  loading: () => WalletHeader(balance: '0.0'),
                  error: (err, stack) => Text('Error: $err'),
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
                    print(ref.read(amountTextProvider.notifier).state);
                    print(ref.read(selectedAmountProvider));
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
                // BankSelection(
                //   bankName: walletData['bankName']!,
                //   accountNumber: walletData['accountNumber']!,
                // ),
                const Spacer(),
                GrowkButton(
                  title: 'Confirm & Add',
                  onTap: () async {
                    final notifier =
                        ref.read(loadWalletAmountNotifierProvider.notifier);
                    final account = ref.read(showWalletBalanceProvider);
                    final amountStr = ref.read(amountTextProvider);
                    final amount = int.parse(amountStr.replaceAll(',', ''));

                    // 🔄 Show button loading
                    ref.read(isButtonLoadingProvider.notifier).state = true;

                    try {
                      await notifier.loadAmount(account, amount);
                      await ref.refresh(getNewWalletBalanceProvider);
                      await ref.refresh(homeDetailsProvider);
                      ref.invalidate(amountTextProvider);
                      showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message:
                            'SAR ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} added to your wallet successfully!',
                        type: SnackType.success,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message: 'Failed to add amount. Please try again.',
                        type: SnackType.error,
                      );
                    } finally {
                      ref.read(isButtonLoadingProvider.notifier).state = false;
                    }
                  },
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
