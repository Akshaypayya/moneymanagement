import 'package:growk_v2/features/wallet_page/provider/wallet_screen_providers.dart';
import 'package:growk_v2/views.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';

class BuyGoldUIWidget extends ConsumerStatefulWidget {
  final double goldPricePerGram;
  final double Function(String, TextStyle) calculateTextWidth;

  const BuyGoldUIWidget({
    super.key,
    required this.goldPricePerGram,
    required this.calculateTextWidth,
  });

  @override
  ConsumerState<BuyGoldUIWidget> createState() => _BuyGoldUIWidgetState();
}

class _BuyGoldUIWidgetState extends ConsumerState<BuyGoldUIWidget> {
  bool isBuyByWeight = true;
  int selectedAmount = 0;
  final List<int> amounts = [101, 501, 1001];
  late TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: '1');
    selectedAmount = (1 * widget.goldPricePerGram).round();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final presetValues = isBuyByWeight ? [1, 5, 10] : amounts;

    final double inputGrams =
        double.tryParse(amountController.text.trim()) ?? 0;
    final String displayValue = isBuyByWeight
        ? (inputGrams * widget.goldPricePerGram).toStringAsFixed(2)
        : widget.goldPricePerGram == 0
        ? "0.000 g"
        : "${(selectedAmount / widget.goldPricePerGram).toStringAsFixed(3)} g";

    return Column(
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
            borderRadius: const BorderRadius.all(Radius.circular(6)),
            child: Row(
              children: [
                _toggleButton("Buy by Weight", isBuyByWeight, AppImages.buyByWeight, () {
                  setState(() {
                    isBuyByWeight = true;
                    selectedAmount = (1 * widget.goldPricePerGram).round();
                    amountController.text = '1';
                  });
                }),
                _toggleButton("Buy by Amount", !isBuyByWeight, AppImages.buyByAmount, () {
                  setState(() {
                    isBuyByWeight = false;
                    selectedAmount = 1001;
                    amountController.text = '1001';
                  });
                }),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isBuyByWeight) ...[
                      Image.asset(AppImages.sarSymbol,
                          color: AppColors.current(isDark).text, height: 25),
                      const SizedBox(width: 6),
                    ],
                    SizedBox(
                      width: widget.calculateTextWidth(
                          amountController.text.isEmpty
                              ? "0"
                              : amountController.text,
                          AppTextStyle.current(isDark).titleLrg) +
                          20,
                      child: TextFormField(
                        controller: amountController,
                        inputFormatters: isBuyByWeight
                            ? AppInputFormatters.gramFormatter()
                            : AppInputFormatters.buyPriceFormatter(),
                        keyboardType: TextInputType.number,
                        textAlign:
                        isBuyByWeight ? TextAlign.center : TextAlign.start,
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
                                : isBuyByWeight
                                ? (input * widget.goldPricePerGram).round()
                                : input.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 5),
              if (isBuyByWeight)
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
          children: presetValues.map((value) {
            final isSelected = isBuyByWeight
                ? (value * widget.goldPricePerGram).round() == selectedAmount
                : value == selectedAmount;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedAmount = isBuyByWeight
                          ? (value * widget.goldPricePerGram).round()
                          : value;
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
                    isBuyByWeight ? "$value gram" : "SAR $value",
                    style: AppTextStyle.current(isDark)
                        .bodySmall
                        .copyWith(color: isSelected ? Colors.white : Colors.black),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 35),
        Text(
          isBuyByWeight
              ? "Enter the weight in grams you wish to buy..."
              : "Enter the amount in SAR you wish to invest...",
          style: AppTextStyle.current(isDark).labelSmall,
        ),
        const SizedBox(height: 35),
        Text("Current Gold Buy Price (24K)",
            style: AppTextStyle.current(isDark).labelSmall),
        const SizedBox(height: 5),
        SarAmountWidget(
          text: "${widget.goldPricePerGram}/g",
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
            style: AppTextStyle.current(isDark).titleLrg),

        const SizedBox(height: 35),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline,
                color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Secure Your Gold Price for 1 Minute\nGold prices update every second based on market rates. Once you proceed, we’ll lock the price for 1 minute.",
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

  Widget _toggleButton(
      String label,
      bool isSelected,
      String icon,
      VoidCallback onTap,
      ) {
    final isDark = ref.watch(isDarkProvider);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isSelected ? Colors.black : Colors.white,
          ),
          alignment: Alignment.center,
          child: ReusableRow(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(icon, height: 18),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyle.current(isDark).titleBottomNav.copyWith(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _proceed(BuildContext context) async {
    final notifier = ref.read(isButtonLoadingProvider.notifier);
    final useCase = ref.read(initiateGoldBuyUseCaseProvider);
    final walletAsync = ref.read(getNewWalletBalanceProvider); // Use .read instead of .watch inside method
    final inputText = amountController.text.trim();

    if (inputText.isEmpty || double.tryParse(inputText) == null || double.parse(inputText) <= 0) {
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Please enter a valid amount',
        type: SnackType.error,
      );
      return;
    }
    final inputAmount = isBuyByWeight
        ? selectedAmount.toDouble()
        : double.parse(inputText);

    if (inputAmount <= 0 || widget.goldPricePerGram <= 0) {
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Gold price or amount is invalid',
        type: SnackType.error,
      );
      return;
    }

    final walletBalance = walletAsync.asData?.value.data?.walletBalance?.toDouble() ?? 0.0;

    if (walletBalance < inputAmount) {
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Insufficient wallet balance',
        type: SnackType.error,
      );
      return;
    }

    try {
      notifier.state = true;

      final result = await useCase.call(inputAmount, 0);

      final transactionId = result.data?.transactionId;
      final transactionAmount = result.data?.transactionAmount;

      if (transactionId == null || transactionId.isEmpty || transactionAmount == null || transactionAmount <= 0) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Transaction initiation failed. Please try again.',
          type: SnackType.error,
        );
        return;
      }

      ref.read(initiateBuyGoldProvider.notifier).setTransaction(result);

      Navigator.pushNamed(context, AppRouter.buyGoldSummary);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction failed: $e')),
      );
    } finally {
      notifier.state = false;
    }
  }

}
