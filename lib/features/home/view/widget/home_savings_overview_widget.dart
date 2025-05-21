import 'package:money_mangmnt/features/home/provider/home_provider.dart';
import '../../../../views.dart';

class HomeSavingsOverviewWidget extends ConsumerWidget {
  const HomeSavingsOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final homeDataAsync = ref.watch(homeDetailsProvider);

    return ScalingFactor(
      child: ReusableWhiteContainerWithPadding(
        widget: homeDataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
          data: (data) {
            final walletBalance = data.data?.walletBalance ?? 0.0;
            final goldBalance = data.data?.goldBalance ?? 0.0;
            final total = walletBalance + goldBalance;

            double walletPercent = 0;
            double goldPercent = 0;
            int walletFlex = 1;
            int goldFlex = 1;

            if (total > 0) {
              walletPercent = (walletBalance / total) * 100;
              goldPercent = (goldBalance / total) * 100;
              walletFlex = ((walletBalance / total) * 1000).round();
              goldFlex = ((goldBalance / total) * 1000).round();
              if (walletFlex == 0) walletFlex = 1;
              if (goldFlex == 0) goldFlex = 1;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableText(
                  text: 'Savings Overview',
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
                          text: "Wallet (${walletPercent.toStringAsFixed(0)}%)",
                          style: AppTextStyle(
                                  textColor: AppColors.current(isDark).text)
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
                          text: "Gold (${goldPercent.toStringAsFixed(0)}%)",
                          style: AppTextStyle(
                                  textColor: AppColors.current(isDark).text)
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
                              : Color(0xFFB7A6FF),
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
                          color: goldBalance == 0
                              ? Colors.grey.shade200
                              : Color(0xFFFFE168),
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
                      style: AppTextStyle(
                              textColor: AppColors.current(isDark).text)
                          .labelRegular,
                    ),
                    ReusableText(
                      text: '${goldPercent.toStringAsFixed(0)}%',
                      style: AppTextStyle(
                              textColor: AppColors.current(isDark).text)
                          .labelRegular,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
