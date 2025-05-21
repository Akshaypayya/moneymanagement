import '../../../../views.dart';
import 'package:intl/intl.dart';
class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final totalSavings = ref.watch(totalSavingsProvider) ?? '0.00';
    final goldWeight = ref.watch(goldWeightProvider) ?? '0.000';

    final savingsDate = DateFormat('d MMM yyyy').format(DateTime.now());


    final bool isKycIncomplete = totalSavings == '0.00' && goldWeight == '0.000';

    return ScalingFactor(
      child: ReusableWhiteContainerWithPadding(
        widget: ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const ReusableSizedBox(height: 30),
            ReusableText(
              text: 'Total Savings',
              style: AppTextStyle(textColor: AppColors.current(isDark).text).titleSmallMedium,
            ),
            ReusableRow(
              children: <Widget>[
                ReusableRow(
                  children: [
                    Image.asset(
                      AppImages.sarSymbol,
                      height: 22,
                      color: AppColors.current(isDark).primary,
                    ),
                    const ReusableSizedBox(width: 5),
                    isKycIncomplete
                        ? ReusableText(
                      text: '0',
                      style: AppTextStyle(
                        textColor: AppColors.current(isDark).text,
                      ).headlineLarge,
                    )
                        : ReusableText(
                      text: totalSavings,
                      style: AppTextStyle(
                        textColor: AppColors.current(isDark).text,
                      ).headlineLarge,
                    ),
                  ],
                ),
                const Spacer(),
                ReusableRow(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.goldPriceTrends);
                      },
                      child: Image.asset(
                        AppImages.rewardsSymbol,
                        height: 30,
                        color: AppColors.current(isDark).primary,
                      ),
                    ),
                    const ReusableSizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.notificationScreen);
                      },
                      child: Image.asset(
                        AppImages.notificationSymbol,
                        height: 30,
                        color: AppColors.current(isDark).primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ReusableRow(
              children: [
                ReusableText(
                  text: 'Gold savings as of $savingsDate:',
                  style: AppTextStyle(textColor: AppColors.current(isDark).text).labelSmall,
                ),
                const ReusableSizedBox(width: 5),
                isKycIncomplete
                    ? ReusableText(
                  text: '0',
                  style: AppTextStyle(
                    textColor: AppColors.current(isDark).text,
                  ).titleSmall,
                )
                    : ReusableText(
                  text: '$goldWeight gm',
                  style: AppTextStyle(textColor: AppColors.current(isDark).text).titleSmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
