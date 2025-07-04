import 'package:growk_v2/core/utils/currency_formatter_utils.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/controller/buy_gold_instantly_screen_controller.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/sell_gold_providers.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/widgets/success_bottomsheet.dart';
import 'package:growk_v2/features/wallet_page/provider/wallet_screen_providers.dart';
import 'package:growk_v2/views.dart';

class SellGoldSummaryPage extends ConsumerStatefulWidget {
  const SellGoldSummaryPage({super.key});

  @override
  ConsumerState<SellGoldSummaryPage> createState() =>
      _SellGoldSummaryPageState();
}

class _SellGoldSummaryPageState extends ConsumerState<SellGoldSummaryPage> {
  int countdown = 20;
  bool _isTimerRunning = true;
  bool _isButtonTapped = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), tick);

    Future.delayed(const Duration(seconds: 20), () {
      if (!_isButtonTapped && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showGrowkSnackBar(
            context: context,
            ref: ref,
            message: "Gold price changed, please proceed again",
            type: SnackType.error,
          );
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) Navigator.pop(context);
        });
      }
    });
  }

  void tick() {
    if (countdown > 0 && _isTimerRunning) {
      setState(() {
        countdown--;
      });
      Future.delayed(const Duration(seconds: 1), tick);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final transaction = ref.watch(initiateBuyGoldProvider);
    final walletAsync = ref.watch(getNewWalletBalanceProvider);
    final liveGoldPriceAsync = ref.watch(liveGoldPriceProvider);
    final double goldPrice =
        liveGoldPriceAsync.asData?.value.data?.sellRate?.toDouble() ?? 0.0;

    final double goldQuantity =
        transaction?.data?.transactionAmount?.toDouble() ?? 0.0;
    final double convenienceFee =
        transaction?.data?.chargeAmount?.toDouble() ?? 0.0;
    final double taxes = 0.0;
    final double creditedAmount = goldQuantity * goldPrice;

    final double totalReceived = creditedAmount - (convenienceFee + taxes);

    return Scaffold(
      backgroundColor: AppColors.current(isDark).background,
      appBar: const GrowkAppBar(
        title: 'Sell Gold Instantly',
        isBackBtnNeeded: true,
      ),
      body: ScalingFactor(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Text(
                    "Price Lock Countdown",
                    style: AppTextStyle.current(isDark).titleSmall,
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "The gold price has been locked for 20 seconds. Complete the sale before the timer expires to get this rate.",
                style: AppTextStyle(textColor: AppColors.current(isDark).text)
                    .labelSmall,
              ),
              const SizedBox(height: 20),
              Center(
                child: CircularPercentIndicator(
                  radius: 65.0,
                  lineWidth: 10.0,
                  percent: countdown / 20,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$countdown",
                        style: AppTextStyle(
                                textColor: AppColors.current(isDark).text)
                            .headlineLarge,
                      ),
                      Text(
                        "Seconds\nRemaining",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.current(isDark).bodyKycSmall,
                      ),
                    ],
                  ),
                  progressColor: Colors.blueAccent,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                "Review Your Sale",
                style: AppTextStyle.current(isDark).titleSmall,
              ),
              const SizedBox(height: 8),
              _buildRow("Gold Price", "${formatCurrency(goldPrice)}/g"),
              _buildRow("Gold Quantity", formatGoldQuantity(goldQuantity)),
              _buildRow("Convenience Fee", formatCurrency(convenienceFee)),
              _buildRow("Taxes", formatCurrency(taxes)),
              _buildRow("Total Credited", formatCurrency(totalReceived),
                  isBold: true),
              const SizedBox(height: 30),
              GrowkButton(
                title: 'Confirm & Sell',
                onTap: () async {
                  final loadingNotifier =
                      ref.read(isButtonLoadingProvider.notifier);
                  loadingNotifier.state = true;
                  _isTimerRunning = false;
                  _isButtonTapped = true;

                  final useCase = ref.read(goldSellUseCaseProvider);
                  final transactionId = transaction?.data?.transactionId ?? '';

                  try {
                    final result = await useCase(goldQuantity, transactionId);

                    if (result.status == 'Success') {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        isDismissible: false,
                        enableDrag: false,
                        builder: (_) => WillPopScope(
                          onWillPop: () async => false,
                          child: SuccessBottomSheet(
                            title: 'Sale Successful',
                            description:
                                'Your gold sale has been completed successfully! The amount will be credited to your GrowK Wallet.',
                            details: {
                              'Gold Quantity': '$goldQuantity g',
                              'Total Credited':
                                  'SAR ${formatCurrency(totalReceived)}',
                            },
                            onClose: () => Navigator.pop(context),
                          ),
                        ),
                      );
                    } else {
                      showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message: result.message ?? 'Sale failed',
                        type: SnackType.error,
                      );
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    showGrowkSnackBar(
                      context: context,
                      ref: ref,
                      message: 'An error occurred: $e',
                      type: SnackType.error,
                    );
                    Navigator.pop(context);
                  } finally {
                    loadingNotifier.state = false;
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    final bool isGramValue = value.trim().toLowerCase().contains('g');
    final isDark = ref.watch(isDarkProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.current(isDark).bodyKycSmall.copyWith(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
                ),
          ),
          isGramValue
              ? Text(value,
                  style: AppTextStyle.current(isDark).bodyKycSmall.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: isBold ? 16 : 12,
                      ))
              : SarAmountWidget(
                  text: value,
                  height: 12,
                  style:  AppTextStyle.current(isDark).bodyKycSmall.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: isBold ? 16 : 12,)
                ),
        ],
      ),
    );
  }
}
