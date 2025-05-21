import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/widgets/growk_app_bar.dart';
import 'package:money_mangmnt/core/widgets/sar_amount_widget.dart';
import 'package:money_mangmnt/views.dart';

class BuyGoldPage extends ConsumerStatefulWidget {
  const BuyGoldPage({super.key});

  @override
  ConsumerState<BuyGoldPage> createState() => _BuyGoldPageState();
}

class _BuyGoldPageState extends ConsumerState<BuyGoldPage> {
  bool isBuyByWeight = true;
  int selectedAmount = 373;
  final List<int> amounts = [101, 501, 1001];
  final double goldPricePerGram = 373.74;
  late TextEditingController amountController;

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

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final inputGrams = double.tryParse(amountController.text) ?? 0;
    final displayValue = isBuyByWeight
        ? "SAR ${(inputGrams * goldPricePerGram).toStringAsFixed(2)}"
        : "${(selectedAmount / goldPricePerGram).toStringAsFixed(3)} g";

    final presetValues = isBuyByWeight ? [1, 5, 10] : amounts;

    return ScalingFactor(
      child: Scaffold(
        appBar: const GrowkAppBar(
          title: 'Buy Gold Instantly',
          isBackBtnNeeded: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: "Choose How You Want to Buy",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.current(isDark).text,
                ),
              ),
              const SizedBox(height: 4),
              ReusableText(
                text:
                    "Switch between buying gold by amount or by weight (grams) for a seamless purchase experience.",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.current(isDark).text,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 50),
              ReusablePadding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: ReusableContainer(
                  borderColor: Colors.black,
                  borderWidth: 1,
                  borderRadius: BorderRadius.all(Radius.circular(11)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              isBuyByWeight = true;
                              selectedAmount = (1 * goldPricePerGram).round();
                              amountController.text = '1';
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              color:
                                  isBuyByWeight ? Colors.black : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: ReusableRow(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppImages.buyByWeight, height: 18),
                                const SizedBox(width: 4),
                                Text("Buy by Weight",
                                    style: TextStyle(
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
                              amountController.text = selectedAmount.toString();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              color:
                                  !isBuyByWeight ? Colors.black : Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: ReusableRow(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(AppImages.buyByAmount, height: 18),
                                const SizedBox(width: 4),
                                Text("Buy by Amount",
                                    style: TextStyle(
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
              const Center(child: Text("99.99% pure 24K gold")),
              const SizedBox(height: 4),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.current(isDark).labelText,
                        width: 1.5,
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!isBuyByWeight) ...[
                        Image.asset(
                          AppImages.sarSymbol,
                          color: AppColors.current(isDark).text,
                          height: 25,
                        ),
                        const SizedBox(width: 6),
                      ],
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
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
                            }
                          },
                        ),
                      ),
                      if (isBuyByWeight == true) ...[],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: presetValues.map((value) {
                  final isSelected = isBuyByWeight
                      ? (value * goldPricePerGram).round() == selectedAmount
                      : value == selectedAmount;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedAmount = isBuyByWeight
                                ? (value * goldPricePerGram).round()
                                : value;
                            amountController.text = value.toString();
                            amountController.selection =
                                TextSelection.fromPosition(
                              TextPosition(
                                  offset: amountController.text.length),
                            );
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isSelected ? Colors.teal : Colors.white,
                          foregroundColor:
                              isSelected ? Colors.white : Colors.black,
                          side: BorderSide(color: Colors.grey.shade400),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child:
                            Text(isBuyByWeight ? "$value gram" : "SAR $value"),
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
                style: const TextStyle(fontSize: 13.5),
              ),
              const SizedBox(height: 35),
              const Text("Current Gold Buy Price (24K)",
                  style: TextStyle(fontSize: 10)),
              const SarAmountWidget(
                  text: "373.74/g",
                  height: 13,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              const Text("Gold You'll Receive / Price You Pay",
                  style: TextStyle(fontSize: 10)),
              Text(displayValue,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 35),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Secure Your Gold Price for 1 Minute\nGold prices update every second based on market rates. Once you proceed, we’ll lock the price for 1 minute to ensure a secure transaction.",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              GrowkButton(
                title: 'Proceed & Lock Price',
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.buyGoldSummary);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
