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
        color: isDark?Colors.white:Colors.black,
        borderRadius: BorderRadius.circular(6), // no round corners like your screen
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔴 LIVE label
          const Icon(Icons.fiber_manual_record, size: 8, color: Colors.red),
          const SizedBox(width: 4),
          Text(
            'LIVE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark?Colors.black:Colors.white,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 6),
          // SAR 400.00
          // SarAmountWidget(
          //   isWhite: isDark ? false : true,
          //   text: goldPrice == 0.00 ? 'Loading..' : '${goldPrice.toStringAsFixed(2)}/g',
          //   height: 12,
          //   style: AppTextStyle.current(isDark).bodyKycSmall.copyWith(
          //       color: isDark ? Colors.black : Colors.white),
          // ),
          Image.asset(
            AppImages.sarSymbol,
            color: isDark?Colors.black:Colors.white,
            height: 11,
          ),
          const SizedBox(width: 2),
          Text(
            goldPrice == 0.00 ? 'Loading..' : '${goldPrice.toStringAsFixed(2)}/g',
            style: AppTextStyle.current(isDark).bodyKycSmall.copyWith(color: isDark?Colors.black:Colors.white,fontSize: 11)
          ),
        ],
      ),
    );
  }
}
