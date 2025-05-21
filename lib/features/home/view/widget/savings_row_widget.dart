import '../../../../views.dart';

class SavingsRowWidget extends ConsumerWidget {
  final String emoji;
  final String title;
  final String profit;
  final Color profitColor;
  final String action;
  final String invested;
  final String current;
  final String growth;
  final String actionIcon;

  const SavingsRowWidget({
    super.key,
    required this.emoji,
    required this.title,
    required this.profit,
    required this.profitColor,
    required this.action,
    required this.invested,
    required this.current,
    required this.growth,
    required this.actionIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset(emoji,
                    height: emoji == AppImages.instantGold ? 12 : 20),
                const SizedBox(width: 8),
                ReusableText(
                  text: title,
                  style: AppTextStyle(textColor: AppColors.current(isDark).text)
                      .titleSmall,
                ),
              ],
            ),
            ReusableRow(
              children: [
                Image.asset(actionIcon, height: 15),
                const SizedBox(width: 5),
                ReusableText(
                    text: action,
                    style:
                        AppTextStyle(textColor: AppColors.current(isDark).text)
                            .labelSmall),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ReusableColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ReusableColumn(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ReusableText(
                      text: 'Profit',
                      style: AppTextStyle(
                              textColor: AppColors.current(isDark).text)
                          .labelSmall,
                    ),
                    Row(
                      children: [
                        Image.asset(AppImages.sarSymbol,
                            color: profitColor, height: 15),
                        const SizedBox(width: 2),
                        ReusableText(
                          text: profit,
                          style: TextStyle(
                            color: profitColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    Image.asset(AppImages.upGreen, height: 10),
                    const SizedBox(width: 2),
                    Text(
                      growth,
                      style: AppTextStyle(
                              textColor: AppColors.current(isDark).text)
                          .titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('Invested: ', style: const TextStyle(fontSize: 13)),
                Image.asset(AppImages.sarSymbol,
                    color: AppColors.current(isDark).text, height: 10),
                const SizedBox(width: 2),
                Text(invested, style: const TextStyle(fontSize: 13)),
              ],
            ),
            Text('Current: $current', style: const TextStyle(fontSize: 13)),
          ],
        ),
      ],
    );
  }
}
