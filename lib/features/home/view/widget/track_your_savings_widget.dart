import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/widgets/reusable_white_container_with_padding.dart';
import 'package:growk_v2/routes/app_router.dart';
import '../../../../views.dart';
import 'savings_row_widget.dart';

class TrackYourSavingsWidget extends ConsumerWidget {
  const TrackYourSavingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = [
      {
        'emoji': AppImages.instantGold,
        'actionIcon': AppImages.buyMoreLite,
        'title': 'Instant Purchase',
        'profit': '0',
        'profitColor': Colors.green,
        'action': 'Buy More',
        'invested': '0',
        'current': '0',
        'growth': '0%',
      },
      {
        'emoji': AppImages.goalDashboard,
        'actionIcon': AppImages.createNewGoal,
        'title': 'Goal Based Savings',
        'profit': '0',
        'profitColor': Colors.green,
        'action': 'Create New',
        'invested': '0',
        'current': '0',
        'growth': '0%',
      },
      {
        'emoji': AppImages.referralDark,
        'actionIcon': AppImages.share,
        'title': 'Referral Rewards',
        'profit': '0',
        'profitColor': Colors.green,
        'action': 'Invite Now',
        'invested': '0',
        'current': '0',
        'growth': '0%',
      },
    ];
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(
      child: ReusableWhiteContainerWithPadding(
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
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    onTap: () async {
                      if (index == 0) {
                        Navigator.pushNamed(
                            context, AppRouter.buyGoldInstantly);
                      } else if (index == 1) {
                        Navigator.pushNamed(
                            context, AppRouter.createGoalScreen);
                      } else if (index == 2) {
                        try {
                          final result =
                              await ref.refresh(homeDetailsProvider.future);
                          Navigator.pushNamed(
                              context, AppRouter.referralRewards);
                        } catch (e) {
                          final errorMessage = e
                                  .toString()
                                  .contains('KYC not completed')
                              ? 'KYC not verified. Please complete KYC to access this feature.'
                              : 'Something went wrong. Please try again later.';

                          showGrowkSnackBar(
                            context: context,
                            ref: ref,
                            message: errorMessage,
                            type: SnackType.error,
                          );
                          await  Navigator.pushNamed(
                              context, AppRouter.kycVerificationScreen);
                        }
                      }
                    },
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
                      ),
                    ),
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
