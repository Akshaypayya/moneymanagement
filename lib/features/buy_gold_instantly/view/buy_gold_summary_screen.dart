import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/buy_gold_instantly/view/widgets/success_bottomsheet.dart';
import 'package:money_mangmnt/features/wallet_page/wallet_page.dart';
import 'package:money_mangmnt/views.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_text_styles.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/core/widgets/sar_amount_widget.dart';

class BuyGoldSummaryPage extends ConsumerStatefulWidget {
  const BuyGoldSummaryPage({super.key});

  @override
  ConsumerState<BuyGoldSummaryPage> createState() => _BuyGoldSummaryPageState();
}

class _BuyGoldSummaryPageState extends ConsumerState<BuyGoldSummaryPage> {
  int countdown = 60;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), tick);
  }

  void tick() {
    if (countdown > 0) {
      setState(() {
        countdown--;
      });
      Future.delayed(const Duration(seconds: 1), tick);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    const double walletBalance = 1547.81;
    const double goldPrice = 373.74;
    const double goldQuantity = 3.547;
    const double goldPurity = 999.9;
    const double investmentAmount = 1750.0;
    const double convenienceFee = 7.25;
    const double taxes = 0.0;
    const double totalPayable = 1757.25;

    final bool hasSufficientBalance = walletBalance >= totalPayable;

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
                  Text("Price Lock Countdown",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "The gold price has been locked for 1 minute to ensure a secure transaction. Complete your payment before the timer expires to secure this rate.",
                style: AppTextStyle(textColor: AppColors.current(isDark).text)
                    .labelSmall,
              ),
              const SizedBox(height: 20),
              Center(
                child: CircularPercentIndicator(
                  radius: 65.0,
                  lineWidth: 10.0,
                  percent: countdown / 60,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$countdown",
                        style: AppTextStyle(
                                textColor: AppColors.current(isDark).text)
                            .headlineLarge,
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
              Text(
                "Wallet Balance",
                style: AppTextStyle(textColor: AppColors.current(isDark).text)
                    .labelSmall,
              ),
              SarAmountWidget(
                height: 16,
                text: "$walletBalance",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              if (!hasSufficientBalance)
                const Text(
                  textAlign: TextAlign.justify,
                  "Insufficient balance! Your GrowK Wallet does not have enough funds to complete this purchase. Please add money to your wallet and try again.",
                  style: TextStyle(color: Colors.red, fontSize: 11.5),
                ),
              if (!hasSufficientBalance)
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.walletPage);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 4.0),
                    child: Text("Add funds to your wallet",
                        style: TextStyle(
                            color: Color.fromRGBO(93, 92, 149, 1),
                            fontWeight: FontWeight.w900)),
                  ),
                ),
              const SizedBox(height: 35),
              const Text("Review Your Purchase",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildRow("Gold Price", " $goldPrice/g"),
              const SizedBox(height: 8),
              _buildRow("Gold Quantity", "$goldQuantity g"),
              const SizedBox(height: 8),
              _buildRow("Gold Purity", "$goldPurity"),
              const SizedBox(height: 8),
              _buildRow("Investment Amount", " $investmentAmount"),
              const SizedBox(height: 8),
              _buildRow("Convenience Fee", " $convenienceFee"),
              const SizedBox(height: 8),
              _buildRow("Taxes", " $taxes"),
              const SizedBox(height: 8),
              _buildRow("Total Payable Amount", " $totalPayable", isBold: true),
              const SizedBox(height: 30),
              GrowkButton(
                title: 'Confirm & Buy',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => SuccessBottomSheet(
                      title: 'Purchase Successful',
                      description:
                          'Your gold purchase has been completed successfully! The amount has been deducted from your GrowK Wallet, and your gold balance has been updated.',
                      details: {
                        'Gold Quantity': '3.547 g',
                        'Investment Amount': '₱ 1,250.00',
                        'Other Charges': '₱ 7.25',
                        'Total Debited Amount': '₱ 1,257.25',
                      },
                      onClose: () => Navigator.pop(context),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
                fontSize: 12),
          ),
          SarAmountWidget(
            text: value,
            height: 12,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.w900 : FontWeight.w900,
                fontSize: isBold ? 16 : 12),
          ),
        ],
      ),
    );
  }
}
