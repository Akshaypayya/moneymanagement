import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/sar_amount_widget.dart';
import '../../../../views.dart';

class GoldPriceDisplay extends ConsumerWidget {
  final double goldPrice;
  final String currency;
  final double? changePercent;

  const GoldPriceDisplay({
    super.key,
    required this.goldPrice,
    this.currency = 'SAR',
    this.changePercent,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(6), // no round corners like your screen
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔴 LIVE label
          const Icon(Icons.fiber_manual_record, size: 8, color: Colors.red),
          const SizedBox(width: 4),
          const Text(
            'LIVE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 6),

          // SAR 400.00
          SarAmountWidget(
            isWhite: true,
            text: '${goldPrice.toStringAsFixed(2)}/g',
            height: 12,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
