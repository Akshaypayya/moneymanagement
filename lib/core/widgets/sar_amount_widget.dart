import '../../views.dart';

class SarAmountWidget extends ConsumerWidget {
  final String text;
  final double height;
  final TextStyle style;
  final Alignment alignment;
  final bool isWhite;

  const SarAmountWidget({
    super.key,
    required this.text,
    required this.height,
    required this.style,
    this.alignment = Alignment.centerLeft,
    this.isWhite = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final color = isWhite ? Colors.white : AppColors.current(isDark).text;

    return Align(
      alignment: alignment,
      child: ScalingFactor(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              AppImages.sarSymbol,
              color: color,
              height: height,
            ),
            const SizedBox(width: 6),
            ReusableText(
              text: text,
              style: style.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
