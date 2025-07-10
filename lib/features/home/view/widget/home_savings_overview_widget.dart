import 'package:growk_v2/core/constants/app_texts_string.dart';

import '../../../../views.dart';

class HomeSavingsOverviewWidget extends ConsumerWidget {
  const HomeSavingsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final homeDataAsync = ref.watch(homeDetailsProvider);
    final texts = ref.watch(appTextsProvider);

    return ScalingFactor(
      child: ReusableWhiteContainerWithPadding(
        widget: homeDataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _buildSavingsOverview(
            context,
            isDark: isDark,
            wallet: 0,
            gold: 0,
            texts: texts,
          ),
          data: (data) {
            final wallet = (data.data?.summary?.walletBalance ?? 0).toDouble();
            final gold = (data.data?.summary?.currentPrice ?? 0).toDouble();
            return _buildSavingsOverview(
              context,
              isDark: isDark,
              wallet: wallet,
              gold: gold,
              texts: texts,
            );
          },
        ),
      ),
    );
  }

  Widget _buildSavingsOverview(
    BuildContext context, {
    required bool isDark,
    required double wallet,
    required double gold,
    required AppTextsString texts,
  }) {
    final total = wallet + gold;

    double walletPercent = 0;
    double goldPercent = 0;
    int walletFlex = 1;
    int goldFlex = 1;

    if (total > 0) {
      walletPercent = (wallet / total) * 100;
      goldPercent = (gold / total) * 100;
      walletFlex = (wallet * 1000 ~/ total).clamp(1, 1000);
      goldFlex = (gold * 1000 ~/ total).clamp(1, 1000);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: texts.savingsOverview,
          style: AppTextStyle(textColor: AppColors.current(isDark).text)
              .titleRegular,
        ),
        const SizedBox(height: 16),

        /// Labels
        ReusableColumn(
          children: [
            ReusableRow(
              children: [
                const CircleAvatar(
                    radius: 6, backgroundColor: Color(0xFFB7A6FF)),
                const SizedBox(width: 6),
                ReusableText(
                  text:
                      "${texts.wallet} (${walletPercent.toStringAsFixed(0)}%)",
                  style: AppTextStyle(textColor: AppColors.current(isDark).text)
                      .labelSmall,
                ),
              ],
            ),
            const SizedBox(height: 15),
            ReusableRow(
              children: [
                const CircleAvatar(
                    radius: 6, backgroundColor: Color(0xFFFFE168)),
                const SizedBox(width: 6),
                ReusableText(
                  text: "${texts.gold} (${goldPercent.toStringAsFixed(0)}%)",
                  style: AppTextStyle(textColor: AppColors.current(isDark).text)
                      .labelSmall,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        /// Proportional Bars
        Row(
          children: [
            Expanded(
              flex: walletFlex,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: walletPercent == 0
                      ? Colors.grey.shade200
                      : const Color(0xFFB7A6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: goldFlex,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  color: goldPercent == 0
                      ? Colors.grey.shade200
                      : const Color(0xFFFFE168),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        /// Percentage Labels
        ReusableRow(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ReusableText(
              text: '${walletPercent.toStringAsFixed(0)}%',
              style: AppTextStyle(textColor: AppColors.current(isDark).text)
                  .labelRegular,
            ),
            ReusableText(
              text: '${goldPercent.toStringAsFixed(0)}%',
              style: AppTextStyle(textColor: AppColors.current(isDark).text)
                  .labelRegular,
            ),
          ],
        ),
      ],
    );
  }
}
