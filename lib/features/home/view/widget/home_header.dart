import 'package:growk_v2/features/buy_gold_instantly/view/controller/buy_gold_instantly_screen_controller.dart';
import 'package:growk_v2/features/home/view/widget/gold_price_display.dart';
import 'package:growk_v2/features/wallet_page/provider/wallet_screen_providers.dart';
import '../../../../views.dart';
import 'package:intl/intl.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);
    final totalSavings = ref.watch(totalSavingsProvider) ?? '0.00';
    final goldWeight = ref.watch(goldWeightProvider) ?? '0.000';
    final walletAsync = ref.watch(getNewWalletBalanceProvider);
    final livePriceAsync = ref.watch(liveGoldPriceProvider);

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 2,
    );
    final savingsDate = DateFormat('d MMM yyyy').format(DateTime.now());
    final isKycIncomplete = totalSavings == '0.00' && goldWeight == '0.000';

    final textColor = AppColors.current(isDark).text;
    final primaryColor = AppColors.current(isDark).primary;

    return ScalingFactor(
      child: ReusableWhiteContainerWithPadding(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                livePriceAsync.when(
                  data: (data) => GoldPriceDisplay(
                    goldPrice: (data.data?.buyRate ?? 0).toDouble(),
                    currency: 'SAR',
                  ),
                  loading: () => const GoldPriceDisplay(
                    goldPrice: 0.00,
                    currency: 'SAR',
                  ),
                  error: (err, _) => const GoldPriceDisplay(
                    goldPrice: 0.00,
                    currency: 'SAR',
                  ),
                ),
                Row(
                  children: [
                    _iconButton(
                      asset: AppImages.rewardsSymbol,
                      color: primaryColor,
                      onTap: () => Navigator.pushNamed(context, AppRouter.goldPriceTrends),
                    ),
                    const SizedBox(width: 12),
                    _iconButton(
                      asset: AppImages.notificationSymbol,
                      color: primaryColor,
                      onTap: () => Navigator.pushNamed(context, AppRouter.notificationScreen),
                    ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),
            ReusableText(
              text: texts.totalSavings,
              style: AppTextStyle(textColor: textColor).titleSmallMedium,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Image.asset(
                  AppImages.sarSymbol,
                  height: 22,
                  color: primaryColor,
                ),
                const SizedBox(width: 6),
                ReusableText(
                  text: formatter.format(double.tryParse(totalSavings) ?? 0),
                  style: AppTextStyle(textColor: textColor).headlineLarge,
                ),
              ],
            ),

            const SizedBox(height: 6),

            GestureDetector(
              onTap: () async {
                try {
                  await ref.refresh(homeDetailsProvider.future);
                  Navigator.pushNamed(context, AppRouter.walletPage);
                } catch (e) {
                  final errorMessage = e.toString().contains('KYC')
                      ? texts.kycNotVerified
                      : texts.genericError;
                  showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: errorMessage,
                    type: SnackType.error,
                  );
                  await Navigator.pushNamed(context, AppRouter.kycVerificationScreen);
                }
              },
              child: ReusableRow(
                children: [
                  ReusableText(
                    text: '${texts.walletBalance}:',
                    style: AppTextStyle(textColor: textColor).labelSmall,
                  ),
                  const SizedBox(width: 6),
                  walletAsync.when(
                    data: (walletData) => ReusableText(
                      text: formatter.format(walletData.data?.walletBalance ?? 0),
                      style: AppTextStyle(textColor: textColor).titleSmall,
                    ),
                    loading: () => ReusableText(
                      text: '0.0',
                      style: AppTextStyle(textColor: textColor).titleSmall,
                    ),
                    error: (_, __) => ReusableText(
                      text: texts.error,
                      style: AppTextStyle(textColor: textColor).titleSmall,
                    ),
                  ),

                ],
              ),
            ),

            const SizedBox(height: 6),

            ReusableRow(
              children: [
                ReusableText(
                  text: '${texts.goldSavingsAsOf} $savingsDate:',
                  style: AppTextStyle(textColor: textColor).labelSmall,
                ),
                const SizedBox(width: 6),
                ReusableText(
                  text: isKycIncomplete ? '0' : '$goldWeight gm',
                  style: AppTextStyle(textColor: textColor).titleSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({required String asset, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        asset,
        height: 24,
        color: color,
      ),
    );
  }
}

