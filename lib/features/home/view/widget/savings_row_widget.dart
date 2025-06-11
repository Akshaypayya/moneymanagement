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
  final bool? received;

  final int index;
  final BuildContext context;
  final WidgetRef ref;

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
    required this.index,
    required this.context,
    required this.ref,
    this.received,
  });

  void _handleTap() async {
    try {
      await ref.refresh(homeDetailsProvider.future);
      if (index == 0) {
        Navigator.pushNamed(context, AppRouter.buyGoldInstantly);
      } else if (index == 1) {
        Navigator.pushNamed(context, AppRouter.createGoalScreen);
      } else if (index == 2) {
        Navigator.pushNamed(context, AppRouter.referralRewards);
      }
    } catch (e) {
      final errorMessage = e.toString().contains('KYC not completed')
          ? 'KYC not verified. Please complete KYC to access this feature.'
          : 'Something went wrong. Please try again later.';

      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: errorMessage,
        type: SnackType.error,
      );

      await Navigator.pushNamed(context, AppRouter.kycVerificationScreen);
    }
  }

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
            GestureDetector(
              onTap: _handleTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ReusableRow(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(actionIcon, height: 15,color: Colors.white,),
                    const SizedBox(width: 5),
                    ReusableText(
                      text: action,
                      style: AppTextStyle(textColor: Colors.white).labelSmall,
                    ),
                  ],
                ),
              ),
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
                Text(received==true?'Received: ':'Invested: ', style:  TextStyle(fontSize: 13,color: AppColors.current(isDark).text)),
                Image.asset(AppImages.sarSymbol,
                    color: AppColors.current(isDark).text, height: 10),
                const SizedBox(width: 2),
                Text(invested, style:  TextStyle(fontSize: 13,color: AppColors.current(isDark).text)),
              ],
            ),
            Text('Current: $current', style:  TextStyle(fontSize: 13,color:  AppColors.current(isDark).text)),
          ],
        ),
      ],
    );
  }
}
