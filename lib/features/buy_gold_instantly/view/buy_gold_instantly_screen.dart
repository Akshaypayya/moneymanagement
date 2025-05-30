import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/controller/buy_gold_instantly_screen_controller.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';
import 'package:growk_v2/views.dart';

class BuyGoldPage extends ConsumerStatefulWidget {
  const BuyGoldPage({super.key});

  @override
  ConsumerState<BuyGoldPage> createState() => _BuyGoldPageState();
}

class _BuyGoldPageState extends ConsumerState<BuyGoldPage> {
  bool isBuyByWeight = true;
  int selectedAmount = 373; // Default, will be overridden once price is fetched
  final List<int> amounts = [101, 501, 1001];
  late TextEditingController amountController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: '1');
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }


  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final livePriceAsync = ref.watch(liveGoldPriceProvider);

    return ScalingFactor(
      child: Scaffold(
        appBar: const GrowkAppBar(
          title: 'Buy Gold Instantly',
          isBackBtnNeeded: true,
        ),
        body: livePriceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error loading price: $err")),
          data: (livePriceData) {
            final double goldPricePerGram =
            (livePriceData.data?.buyRate ?? 0).toDouble();

            if (!_isInitialized && goldPricePerGram > 0) {
              selectedAmount = (1 * goldPricePerGram).round();
              amountController.text = '1';
              _isInitialized = true;
            }

            final double inputGrams =
                double.tryParse(amountController.text) ?? 0;
            final String displayValue = isBuyByWeight
                ? (inputGrams * goldPricePerGram).toStringAsFixed(2)
                : goldPricePerGram == 0
                ? "0.000 g"
                : "${(selectedAmount / goldPricePerGram).toStringAsFixed(3)} g";
            final List<int> presetValues =
            isBuyByWeight ? [1, 5, 10] : amounts;

            return SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                      text: "Choose How You Want to Buy",
                      style: AppTextStyle.current(isDark).titleSmall),
                  const SizedBox(height: 8),
                  ReusableText(
                    text:
                    "Switch between buying gold by amount or by weight (grams) for a seamless purchase experience.",
                    style: AppTextStyle.current(isDark).labelSmall,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 40),
                  ReusablePadding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ReusableContainer(
                      borderColor: Colors.grey.shade400,
                      borderWidth: 1,
                      borderRadius:
                      const BorderRadius.all(Radius.circular(6)),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBuyByWeight = true;
                                  selectedAmount =
                                      (1 * goldPricePerGram).round();
                                  amountController.text = '1';
                                });
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 9),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: isBuyByWeight
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: ReusableRow(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(AppImages.buyByWeight,
                                        height: 18),
                                    const SizedBox(width: 4),
                                    Text("Buy by Weight",
                                        style: AppTextStyle.current(isDark)
                                            .titleBottomNav
                                            .copyWith(
                                            color: isBuyByWeight
                                                ? Colors.white
                                                : Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isBuyByWeight = false;
                                  selectedAmount = 1001;
                                  amountController.text =
                                      selectedAmount.toString();
                                });
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 9),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(5)),
                                  color: !isBuyByWeight
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                alignment: Alignment.center,
                                child: ReusableRow(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(AppImages.buyByAmount,
                                        height: 18),
                                    const SizedBox(width: 4),
                                    Text("Buy by Amount",
                                        style: AppTextStyle.current(isDark)
                                            .titleBottomNav
                                            .copyWith(
                                            color: !isBuyByWeight
                                                ? Colors.white
                                                : Colors.black)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                      child: Text("99.99% pure 24K gold",
                          style: AppTextStyle.current(isDark).bodySmall)),
                  const SizedBox(height: 10),
                  Center(
                    child: ReusableRow(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.current(isDark).labelText,
                                width: 1.5,
                              ),
                            ),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!isBuyByWeight) ...[
                                Image.asset(AppImages.sarSymbol,
                                    color: AppColors.current(isDark).text,
                                    height: 25),
                                const SizedBox(width: 6),
                              ],
                              SizedBox(
                                width: _calculateTextWidth(amountController.text.isEmpty ? "0" : amountController.text, AppTextStyle.current(isDark).titleLrg) + 20,
                                child: TextFormField(
                                  inputFormatters: isBuyByWeight
                                      ? AppInputFormatters.gramFormatter()
                                      : AppInputFormatters.buyPriceFormatter(),
                                  controller: amountController,
                                  keyboardType: TextInputType.number,
                                  textAlign: isBuyByWeight ? TextAlign.center : TextAlign.start,
                                  style: AppTextStyle.current(isDark).titleLrg,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    isCollapsed: true,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  onChanged: (value) {
                                    final input = double.tryParse(value);
                                    if (input != null) {
                                      setState(() {
                                        selectedAmount = isBuyByWeight
                                            ? (input * goldPricePerGram).round()
                                            : input.round();
                                      });
                                    } else {
                                      setState(() {
                                        selectedAmount = 0;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const ReusableSizedBox(width: 5),
                        if (isBuyByWeight)
                          ReusableText(
                            text: 'gram',
                            style: AppTextStyle.current(isDark)
                                .titleRegular
                                .copyWith(
                                color: Colors.grey.shade700),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 35),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: presetValues.map((value) {
                      final isSelected = isBuyByWeight
                          ? (value * goldPricePerGram).round() ==
                          selectedAmount
                          : value == selectedAmount;
                      return Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedAmount = isBuyByWeight
                                    ? (value * goldPricePerGram).round()
                                    : value;
                                amountController.text =
                                    value.toString();
                                amountController.selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                          offset:
                                          amountController.text.length),
                                    );
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: isSelected
                                  ? Colors.teal
                                  : Colors.white,
                              foregroundColor: isSelected
                                  ? Colors.white
                                  : Colors.black,
                              side: BorderSide(
                                  color: Colors.grey.shade400),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5),
                              ),
                            ),
                            child: Text(
                              isBuyByWeight
                                  ? "$value gram"
                                  : "SAR $value",
                              style: AppTextStyle.current(isDark)
                                  .bodySmall
                                  .copyWith(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 35),
                  Text(
                    isBuyByWeight
                        ? "Enter the weight in grams you wish to buy, and we’ll calculate the total price."
                        : "Enter the amount in SAR you wish to invest, and we’ll calculate the gold you’ll receive based on the latest market price.",
                    style: AppTextStyle.current(isDark).labelSmall,
                  ),
                  const SizedBox(height: 35),
                  Text("Current Gold Buy Price (24K)",
                      style: AppTextStyle.current(isDark).labelSmall),
                  const SizedBox(height: 5),
                  SarAmountWidget(
                    text: "$goldPricePerGram/g",
                    height: 15,
                    style: AppTextStyle.current(isDark).titleRegular,
                  ),
                  const SizedBox(height: 20),
                  Text("Gold You'll Receive / Price You Pay",
                      style: AppTextStyle.current(isDark).labelSmall),
                  const SizedBox(height: 5),
                  isBuyByWeight
                      ? SarAmountWidget(
                    text: displayValue,
                    height: 20,
                    style: AppTextStyle.current(isDark).titleLrg,
                  )
                      : Text(displayValue,
                      style:
                      AppTextStyle.current(isDark).titleLrg),
                  const SizedBox(height: 35),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Secure Your Gold Price for 1 Minute\nGold prices update every second based on market rates. Once you proceed, we’ll lock the price for 1 minute to ensure a secure transaction.",
                          style:
                          AppTextStyle.current(isDark).labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 35),
                  GrowkButton(
                    title: 'Proceed & Lock Price',
                      onTap: () async {
                        final notifier = ref.read(isButtonLoadingProvider.notifier);
                        final useCase = ref.read(initiateGoldBuyUseCaseProvider);
                        final inputText = amountController.text.trim();

                        if (inputText.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid amount')),
                          );
                          return;
                        }

                        final inputAmount = double.tryParse(inputText);
                        if (inputAmount == null || inputAmount <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a valid number')),
                          );
                          return;
                        }

                        final amountToPass = isBuyByWeight ? selectedAmount.toDouble() : inputAmount;

                        try {
                          notifier.state = true; // 🔄 Show loading
                          final result = await useCase.call(amountToPass);
                          ref.read(initiateBuyGoldProvider.notifier).setTransaction(result);

                          showGrowkSnackBar(
                            context: context,
                            ref: ref,
                            message: 'Transaction initiated successfully',
                            type: SnackType.success,
                          );
                          Navigator.pushNamed(context, AppRouter.buyGoldSummary);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Transaction failed: $e')),
                          );
                        } finally {
                          notifier.state = false; // ✅ Hide loading
                        }
                      }
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
