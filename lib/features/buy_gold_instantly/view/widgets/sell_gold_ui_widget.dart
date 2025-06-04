import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/views.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';

class SellGoldUIWidget extends ConsumerStatefulWidget {
  final double goldSellPricePerGram;
  final double Function(String, TextStyle) calculateTextWidth;

  const SellGoldUIWidget({
    super.key,
    required this.goldSellPricePerGram,
    required this.calculateTextWidth,
  });

  @override
  ConsumerState<SellGoldUIWidget> createState() => _SellGoldUIWidgetState();
}

class _SellGoldUIWidgetState extends ConsumerState<SellGoldUIWidget> {
  int selectedAmount = 0;
  final List<int> gramOptions = [1, 5, 10];
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: '1');
    selectedAmount = (1 * widget.goldSellPricePerGram).round();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    final double inputGrams =
        double.tryParse(amountController.text.trim()) ?? 0;
    final String displayValue =
    (inputGrams * widget.goldSellPricePerGram).toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
            text: "Sell Gold by Weight",
            style: AppTextStyle.current(isDark).titleSmall),
        const SizedBox(height: 8),
        ReusableText(
          text:
          "Enter the weight in grams you wish to sell. We’ll calculate the amount you’ll receive based on the current market price.",
          style: AppTextStyle.current(isDark).labelSmall,
          maxLines: 3,
        ),
        const SizedBox(height: 40),
        Center(
          child: Text("99.99% pure 24K gold",
              style: AppTextStyle.current(isDark).bodySmall),
        ),
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
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                  width: widget.calculateTextWidth(
                      amountController.text.isEmpty
                          ? "0"
                          : amountController.text,
                      AppTextStyle.current(isDark).titleLrg) +
                      20,
                  child: TextFormField(
                    controller: amountController,
                    inputFormatters: AppInputFormatters.gramFormatter(),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.current(isDark).titleLrg,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) {
                      final input = double.tryParse(value);
                      setState(() {
                        selectedAmount = input == null
                            ? 0
                            : (input * widget.goldSellPricePerGram).round();
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(width: 5),
              ReusableText(
                text: 'gram',
                style: AppTextStyle.current(isDark)
                    .titleRegular
                    .copyWith(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: gramOptions.map((value) {
            final isSelected =
                (value * widget.goldSellPricePerGram).round() == selectedAmount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAmount =
                          (value * widget.goldSellPricePerGram).round();
                      amountController.text = value.toString();
                      amountController.selection = TextSelection.fromPosition(
                        TextPosition(offset: amountController.text.length),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: isSelected ? Colors.teal : Colors.white,
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                    side: BorderSide(color: Colors.grey.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    "$value gram",
                    style: AppTextStyle.current(isDark).bodySmall.copyWith(
                        color: isSelected ? Colors.white : Colors.black),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 35),
        Text("Current Gold Sell Price (24K)",
            style: AppTextStyle.current(isDark).labelSmall),
        const SizedBox(height: 5),
        SarAmountWidget(
          text: "${widget.goldSellPricePerGram}/g",
          height: 15,
          style: AppTextStyle.current(isDark).titleRegular,
        ),
        const SizedBox(height: 20),
        Text("You Will Receive",
            style: AppTextStyle.current(isDark).labelSmall),
        const SizedBox(height: 5),
        SarAmountWidget(
          text: displayValue,
          height: 20,
          style: AppTextStyle.current(isDark).titleLrg,
        ),
        const SizedBox(height: 35),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline,
                color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Gold prices are market-driven. Once you proceed, we’ll lock the price for 1 minute to secure your transaction.",
                style: AppTextStyle.current(isDark).labelSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 35),
        GrowkButton(
          title: 'Proceed & Lock Price',
          onTap: () => _proceed(context),
        ),
      ],
    );
  }

  void _proceed(BuildContext context) async {
    final notifier = ref.read(isButtonLoadingProvider.notifier);
    final useCase = ref.read(initiateGoldBuyUseCaseProvider); // still reused
    final inputText = amountController.text.trim();

    final goldInGrams = double.tryParse(inputText);

    if (goldInGrams == null || goldInGrams <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid gram value')),
      );
      return;
    }

    try {
      notifier.state = true;
      final result = await useCase.call(goldInGrams, 1); // gram quantity passed to sell API
      ref.read(initiateBuyGoldProvider.notifier).setTransaction(result);

      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Transaction initiated successfully',
        type: SnackType.success,
      );
      Navigator.pushNamed(context, AppRouter.sellGoldSummaryPage);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: $e')),
      );
    } finally {
      notifier.state = false;
    }
  }
}
