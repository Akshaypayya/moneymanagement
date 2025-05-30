import 'package:growk_v2/features/wallet_page/provider/wallet_screen_providers.dart';
import 'package:growk_v2/features/wallet_page/wallet_page.dart';
import 'package:growk_v2/views.dart';
class WalletPageButton extends ConsumerWidget {
  const WalletPageButton({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ReusableSizedBox(
      height: 150,
      child: GrowkButton(
        title: 'Confirm & Add',
        onTap: () async {
          final notifier = ref.read(loadWalletAmountNotifierProvider.notifier);
          final account = ref.read(showWalletBalanceProvider);
          final amountStr = ref.read(amountTextProvider);
          final amount = int.parse(amountStr.replaceAll(',', ''));
          ref.read(isButtonLoadingProvider.notifier).state = true;
          try {
            await notifier.loadAmount(account, amount);
            await ref.refresh(getNewWalletBalanceProvider);
            await ref.refresh(homeDetailsProvider);
            ref.invalidate(amountTextProvider);
            showGrowkSnackBar(
              context: context,
              ref: ref,
              message: 'SAR ${amount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')} added to your wallet successfully!',
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
    );
  }
}
