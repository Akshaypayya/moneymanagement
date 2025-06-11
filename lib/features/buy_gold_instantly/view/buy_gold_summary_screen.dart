import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/controller/buy_gold_instantly_screen_controller.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/widgets/success_bottomsheet.dart';
import 'package:growk_v2/features/wallet_page/wallet_page.dart';
import 'package:growk_v2/views.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import '../../wallet_page/provider/wallet_screen_providers.dart';

class BuyGoldSummaryPage extends ConsumerStatefulWidget {
  const BuyGoldSummaryPage({super.key});

  @override
  ConsumerState<BuyGoldSummaryPage> createState() => _BuyGoldSummaryPageState();
}

class _BuyGoldSummaryPageState extends ConsumerState<BuyGoldSummaryPage> {
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
    final double goldPrice = liveGoldPriceAsync.asData?.value.data?.buyRate?.toDouble() ?? 0.0;

    const double goldQuantity = 3.547;
    const double goldPurity = 999.9;

    final double investmentAmount = transaction?.data?.transactionAmount?.toDouble() ?? 0.0;
    final double convenienceFee = transaction?.data?.chargeAmount?.toDouble() ?? 0.0;
    final double taxes = transaction?.data?.chargeAmount?.toDouble() ?? 0.0;

    final double totalPayable = investmentAmount + convenienceFee + taxes;
    String _calculateGoldQuantity(double amount, double goldRate) {
      if (goldRate <= 0) return '0.000 g';
      final quantity = amount / goldRate;
      return '${quantity.toStringAsFixed(3)} g';
    }


    return Scaffold(
      appBar: const GrowkAppBar(
        title: 'Buy Gold Instantly',
        isBackBtnNeeded: true,
      ),
      body: ScalingFactor(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Text("Price Lock Countdown", style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "The gold price has been locked for 20 seconds to ensure a secure transaction. Complete your payment before the timer expires to secure this rate.",
                style: AppTextStyle(textColor: AppColors.current(isDark).text).labelSmall,
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
                        style: AppTextStyle(textColor: AppColors.current(isDark).text).headlineLarge,
                      ),
                      const Text(
                        "Seconds\nRemaining",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  progressColor: Colors.blueAccent,
                  backgroundColor: Colors.grey.shade200,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(height: 30),
              Text("Wallet Balance", style: AppTextStyle(textColor: AppColors.current(isDark).text).labelSmall),
              walletAsync.when(
                data: (walletData) {
                  final walletBalance = walletData.data?.walletBalance?.toDouble() ?? 0.0;
                  final bool hasSufficientBalance = walletBalance >= totalPayable;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SarAmountWidget(
                        height: 16,
                        text: walletBalance.toStringAsFixed(2),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      if (!hasSufficientBalance) ...[
                        const SizedBox(height: 6),
                        const Text(
                          "Insufficient balance! Your GrowK Wallet does not have enough funds to complete this purchase. Please add money to your wallet and try again.",
                          textAlign: TextAlign.justify,
                          style: TextStyle(color: Colors.red, fontSize: 11.5),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, AppRouter.walletPage);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 4.0),
                            child: Text(
                              "Add funds to your wallet",
                              style: TextStyle(
                                color: Color.fromRGBO(93, 92, 149, 1),
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ]
                    ],
                  );
                },
                loading: () => const SarAmountWidget(
                  height: 16,
                  text: "0.0",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                error: (err, stack) => Text('Error: $err'),
              ),

              // if (!hasSufficientBalance)
              //   const Text(
              //     textAlign: TextAlign.justify,
              //     "Insufficient balance! Your GrowK Wallet does not have enough funds to complete this purchase. Please add money to your wallet and try again.",
              //     style: TextStyle(color: Colors.red, fontSize: 11.5),
              //   ),
              // if (!hasSufficientBalance)
              //   GestureDetector(
              //     onTap: () {
              //       Navigator.pushNamed(context, AppRouter.walletPage);
              //     },
              //     child: const Padding(
              //       padding: EdgeInsets.only(top: 4.0),
              //       child: Text(
              //         "Add funds to your wallet",
              //         style: TextStyle(
              //           color: Color.fromRGBO(93, 92, 149, 1),
              //           fontWeight: FontWeight.w900,
              //         ),
              //       ),
              //     ),
              //   ),
              const SizedBox(height: 35),
              const Text("Review Your Purchase", style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildRow("Gold Price", "${goldPrice.toStringAsFixed(2)}/g"),
              const SizedBox(height: 8),
              _buildRow("Gold Quantity", _calculateGoldQuantity(investmentAmount, goldPrice)),
              const SizedBox(height: 8),
              _buildRow("Gold Purity", "$goldPurity"),
              const SizedBox(height: 8),
              _buildRow("Investment Amount", "$investmentAmount"),
              const SizedBox(height: 8),
              _buildRow("Convenience Fee", "$convenienceFee"),
              const SizedBox(height: 8),
              _buildRow("Taxes", "$taxes"),
              const SizedBox(height: 8),
              _buildRow("Total Payable Amount", "$totalPayable", isBold: true),
              const SizedBox(height: 30),
              GrowkButton(
                title: 'Confirm & Buy',
                  onTap: () async {
                    final loadingNotifier = ref.read(isButtonLoadingProvider.notifier);
                    loadingNotifier.state = true;
                    _isTimerRunning = false;
                    _isButtonTapped = true;

                    final useCase = ref.read(goldBuyUseCaseProvider);
                    final transaction = ref.read(initiateBuyGoldProvider);
                    final debitAmount = (transaction?.data?.transactionAmount ?? 0.0).toDouble();
                    final transactionId = transaction?.data?.transactionId ?? '';

                    if (debitAmount <= 0 || transactionId.isEmpty) {
                      showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message: 'Invalid transaction details. Please try again.',
                        type: SnackType.error,
                      );
                      loadingNotifier.state = false;
                      return;
                    }

                    final String goldQuantityText = _calculateGoldQuantity(investmentAmount, goldPrice);

                    try {
                      final result = await useCase(debitAmount, transactionId);

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
                              title: 'Purchase Successful',
                              description: 'Your gold purchase has been completed successfully! The amount has been deducted from your GrowK Wallet, and your gold balance has been updated.',
                              details: {
                                'Gold Quantity': goldQuantityText,
                                'Investment Amount': 'SAR ${debitAmount.toStringAsFixed(2)}',
                                'Other Charges': 'SAR ${(taxes + convenienceFee).toStringAsFixed(2)}',
                                'Total Debited Amount': 'SAR ${(debitAmount + taxes + convenienceFee).toStringAsFixed(2)}',
                              },
                              onClose: () => Navigator.pop(context),
                            ),
                          ),
                        );
                      } else {
                        showGrowkSnackBar(
                          context: context,
                          ref: ref,
                          message: result.message ?? 'Purchase failed',
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
                  }
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    final bool isGramValue = value.trim().toLowerCase().contains('g');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
              fontSize: 12,
            ),
          ),
          isGramValue
              ? Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isBold ? 16 : 12,
            ),
          )
              : SarAmountWidget(
            text: value,
            height: 12,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: isBold ? 16 : 12,
            ),
          ),
        ],
      ),
    );
  }
}
