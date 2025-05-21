import '../../views.dart';

class SarAmountWidget extends ConsumerWidget {
  final String text;
  final double height;
  final TextStyle style;
  final Alignment alignment; // 🔥 Add this

  const SarAmountWidget({
    super.key,
    required this.text,
    required this.height,
    required this.style,
    this.alignment = Alignment.centerLeft, // 🔥 Default left align
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return Align( // 🔥 Wrap everything inside Align
      alignment: alignment,
      child: ScalingFactor(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Image.asset(
              AppImages.sarSymbol,
              color: AppColors.current(isDark).text,
              height: height,
            ),
            const SizedBox(width: 6),
            ReusableText(
              text: text,
              style: style,
            )
          ],
        ),
      ),
    );
  }
}
