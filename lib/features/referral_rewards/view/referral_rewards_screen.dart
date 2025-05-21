import 'package:money_mangmnt/features/referral_rewards/provider/referrel_rewards_notifier.dart';
import 'package:money_mangmnt/views.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/views.dart';
import 'package:share_plus/share_plus.dart'; // if not already imported
import 'package:flutter/services.dart'; // for Clipboard

class ReferralRewardsPage extends ConsumerWidget {
  const ReferralRewardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final rewards = ref.watch(referralRewardsProvider);

    return Scaffold(
      backgroundColor: AppColors.current(isDark).scaffoldBackground,
      appBar: const GrowkAppBar(
        title: "My Referral Rewards",
        isBackBtnNeeded: true,
      ),
      body: ScalingFactor(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableWhiteContainerWithPadding(
                widget: ReusableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Total Referral Rewards",
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    const Text("1.129 g",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child:
                              Image.asset(AppImages.referralDark, height: 36),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Share & Earn Gold",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              SizedBox(height: 4),
                              Text(
                                "Invite friends to GrowK and earn rewards! Share your referral code—get gold worth 10 SAR when they complete their first transaction!",
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black,
                            ),
                            child: const Text("CY56YZ3",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            Clipboard.setData(
                                const ClipboardData(text: "CY56YZ3"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Referral code copied!")),
                            );
                          },
                          child: const Icon(Icons.copy_rounded),
                        ),
                        const SizedBox(width: 10),
                        InkWell(
                          onTap: () => Share.share(
                              "Use my GrowK referral code CY56YZ3 and earn gold!"),
                          child: const Icon(Icons.share_rounded),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      textAlign: TextAlign.justify,
                      "You will receive gold worth 10 SAR only after the referred user successfully completes their first transaction. Referral rewards are subject to change and are governed by GrowK's terms and conditions.",
                      style: TextStyle(fontSize: 11),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              ReusableWhiteContainerWithPadding(
                widget: ReusableColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("2025", style: TextStyle(fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text("Reward History",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    ...rewards.map((reward) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(reward.avatarUrl),
                                radius: 20,
                                backgroundColor: Colors.transparent,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(reward.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 2),
                                    const Text(
                                      "Your referral reward has been credited successfully!",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(reward.dateTime,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              Text("${reward.goldReceived} g",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
