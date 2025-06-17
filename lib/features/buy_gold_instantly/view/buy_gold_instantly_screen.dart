import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/common_tab_widget.dart';
import 'package:growk_v2/core/widgets/growk_app_bar.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/controller/buy_gold_instantly_screen_controller.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/widgets/buy_gold_ui_widget.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/widgets/sell_gold_ui_widget.dart';
import 'package:growk_v2/views.dart';
class BuyGoldPage extends ConsumerStatefulWidget {
  const BuyGoldPage({super.key});

  @override
  ConsumerState<BuyGoldPage> createState() => _BuyGoldPageState();
}

class _BuyGoldPageState extends ConsumerState<BuyGoldPage> {
  bool isBuyByWeight = true;
  int selectedAmount = 373;
  final List<int> amounts = [101, 501, 1001];
  late TextEditingController amountController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController(text: '1');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      Future.microtask(() {
        ref.read(selectedGoldTabProvider.notifier).state = 'Buy Gold';
      });
      _isInitialized = true;
    }
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
    final selectedTab = ref.watch(selectedGoldTabProvider);

    return ScalingFactor(
      child: Scaffold(
        appBar: const GrowkAppBar(
          title: 'Instant Gold Trade',
          isBackBtnNeeded: true,
        ),
        body: livePriceAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error loading price: $err")),
          data: (livePriceData) {
            final double goldPricePerGram =
            double.parse((livePriceData.data?.buyRate ?? 0).toStringAsFixed(2));
            final String sellPricePerGramFormatted =
            (livePriceData.data?.sellRate?.toDouble() ?? 0).toStringAsFixed(2);


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
                  CommonTabWidget(
                    itemCount: 2,
                    itemNames: ['Buy Gold', 'Sell Gold'],
                    selectedItem: selectedTab,
                    onItemSelected: (val) {
                      ref.read(selectedGoldTabProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(height: 30),
                  if (selectedTab == 'Buy Gold')
                    BuyGoldUIWidget(
                      goldPricePerGram: goldPricePerGram,
                      calculateTextWidth: _calculateTextWidth,
                    )
                  else
                    SellGoldUIWidget(
                      goldSellPricePerGram:
                      livePriceData.data?.sellRate?.toDouble() ?? 0,
                      calculateTextWidth: _calculateTextWidth,
                    )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
