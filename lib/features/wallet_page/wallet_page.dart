import 'package:growk_v2/features/wallet_page/provider/wallet_screen_providers.dart';
import 'package:growk_v2/features/wallet_page/widgets/add_funds_section.dart';
import 'package:growk_v2/features/wallet_page/widgets/bank_selection.dart';
import 'package:growk_v2/features/wallet_page/widgets/wallet_description.dart';
import 'package:growk_v2/features/wallet_page/widgets/wallet_header.dart';
import 'package:growk_v2/features/wallet_page/widgets/wallet_page_button.dart';
import 'package:growk_v2/features/wallet_page/widgets/wallet_standing_instructions.dart';

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
      child: ScalingFactor(
        child: Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          appBar: GrowkAppBar(title: 'Wallet', isBackBtnNeeded: true),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  walletAsync.when(
                    data: (walletData) =>
                        WalletHeader(balance: "${walletData.data?.walletBalance ?? 0.0}"),
                    loading: () => WalletHeader(balance: '0.0'),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                  const WalletDescription(),
                  const SizedBox(height: 30),
                  // AddFundsSection(
                  //   amountOptions: amountOptions,
                  //   selectedAmount: selectedAmount,
                  //   onAmountSelected: (value) {
                  //     ref.read(selectedAmountProvider.notifier).state = value;
                  //
                  //     final formattedAmount = value.toString().replaceAllMapped(
                  //         RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                  //             (Match match) => '${match[1]},');
                  //
                  //     ref.read(amountTextProvider.notifier).state = formattedAmount;
                  //     print(ref.read(amountTextProvider.notifier).state);
                  //     print(ref.read(selectedAmountProvider));
                  //   },
                  //   onAmountChanged: (value) {
                  //     ref.read(amountTextProvider.notifier).state = value;
                  //
                  //     final parsedValue = int.tryParse(value.replaceAll(',', '')) ?? 0;
                  //
                  //     ref.read(selectedAmountProvider.notifier).state = parsedValue;
                  //   },
                  //   amount: ref.watch(amountTextProvider),
                  // ),
                  WalletStandingInstruction(
                    bankId: 'Arab National Bank',
                    ibanAccount: ref.watch(showWalletBalanceProvider),
                    accountName: 'Nexus Global Limited or Growk',
                  ),
                  // BankSelection(
                  //   bankName: 'Virtual Account',
                  //   accountNumber: ref.watch(showWalletBalanceProvider),
                  // ),
                  // const Spacer(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          // bottomNavigationBar: WalletPageButton(),
        ),
      ),
    );
  }
}
