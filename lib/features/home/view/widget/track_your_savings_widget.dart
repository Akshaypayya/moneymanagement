import 'package:intl/intl.dart';

import '../../../../views.dart';
import 'savings_row_widget.dart';

class TrackYourSavingsWidget extends ConsumerWidget {
  const TrackYourSavingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(homeDetailsProvider);
    final isDark = ref.watch(isDarkProvider);
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 2,
    );

    final goals = homeDataAsync.valueOrNull?.data?.goals ?? Goals();
    final referral = homeDataAsync.valueOrNull?.data?.referral ?? Referral();
    final wallet = homeDataAsync.valueOrNull?.data?.wallet ?? Wallet();
    final data = [
      {
        'emoji': AppImages.instantGold,
        'actionIcon': AppImages.buyMoreLite,
        'title': 'Instant Gold Trade',
        'profit': formatter.format((wallet.currentPrice ?? 0) - (wallet.buyPrice ?? 0)),
        'profitColor': ((wallet.currentPrice ?? 0) - (wallet.buyPrice ?? 0)) >= 0
            ? Colors.green
            : Colors.red,
        'action': 'Buy/sell',
        'invested': "${(wallet.goldBalance ?? 0).toStringAsFixed(3)} gm ",
        'current': formatter.format(wallet.currentPrice ?? 0),
        'growth': (wallet.buyPrice ?? 0) != 0
            ? '${((((wallet.currentPrice ?? 0) - wallet.buyPrice!) / wallet.buyPrice!) * 100).toStringAsFixed(1)}%'
            : '0%',
        'goldSavings': true,
        'goldAmount': formatter.format(wallet.buyPrice ?? 0),
      },
      {
        'emoji': AppImages.goalDashboard,
        'actionIcon': AppImages.createNewGoal,
        'title': 'Goal Based Savings',
        'profit': formatter.format((goals.currentPrice ?? 0) - (goals.buyPrice ?? 0)),
        'profitColor': ((goals.currentPrice ?? 0) - (goals.buyPrice ?? 0)) >= 0
            ? Colors.green
            : Colors.red,
        'action': 'Create New',
        'invested': "${(goals.goldBalance ?? 0).toStringAsFixed(3)} gm ",
        'current': formatter.format(goals.currentPrice ?? 0),
        'growth': (goals.buyPrice ?? 0) != 0
            ? '${((((goals.currentPrice ?? 0) - goals.buyPrice!) / goals.buyPrice!) * 100).toStringAsFixed(1)}%'
            : '0%',
        'goldSavings': true,
        'goldAmount': formatter.format(goals.buyPrice ?? 0),
      },
      {
        'emoji': AppImages.referralDark,
        'actionIcon': AppImages.share,
        'title': 'Referral Rewards',
        'profit': formatter.format((referral.currentPrice ?? 0) - (referral.buyPrice ?? 0)),
        'profitColor': ((referral.currentPrice ?? 0) - (referral.buyPrice ?? 0)) >= 0
            ? Colors.green
            : Colors.red,
        'action': 'Invite Now',
        'invested': "${formatter.format(referral.buyPrice ?? 0)} (${(referral.goldBalance ?? 0).toStringAsFixed(3)} gm )",
        'current': formatter.format(referral.currentPrice ?? 0),
        'growth': (referral.buyPrice ?? 0) != 0
            ? '${((((referral.currentPrice ?? 0) - referral.buyPrice!) / referral.buyPrice!) * 100).toStringAsFixed(1)}%'
            : '0%',
        'received': true,
      },
    ];


    return ScalingFactor(
      child: ReusableWhiteContainerWithPadding(
        applyBottomPadding: false,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Track Your Savings",
                style: AppTextStyle(textColor: AppColors.current(isDark).text)
                    .titleRegular),
            const SizedBox(height: 16),
            ...List.generate(data.length, (index) {
              final item = data[index];
              return Padding(
                padding:
                    EdgeInsets.only(bottom: index == data.length - 1 ? 0 : 35),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: SavingsRowWidget(
                    actionIcon: item['actionIcon'].toString(),
                    emoji: item['emoji'].toString(),
                    title: item['title'].toString(),
                    profit: item['profit'].toString(),
                    profitColor: item['profitColor'] as Color,
                    action: item['action'].toString(),
                    invested: item['invested'].toString(),
                    current: item['current'].toString(),
                    growth: item['growth'].toString(),
                    received: item['received'] as bool? ?? false,
                    goldSavings: item['goldSavings'] as bool? ?? false,
                    index: index,
                    goldAmount:  item['goldAmount'].toString(),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
