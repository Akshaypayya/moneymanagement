import 'package:flutter/services.dart';
import 'package:growk_v2/features/referral_rewards/provider/referrel_rewards_notifier.dart';
import 'package:growk_v2/views.dart';

class ReferralRewardsPage extends ConsumerStatefulWidget {
  const ReferralRewardsPage({super.key});

  @override
  ConsumerState<ReferralRewardsPage> createState() =>
      _ReferralRewardsPageState();
}

class _ReferralRewardsPageState extends ConsumerState<ReferralRewardsPage> {
  @override
  void initState() {
    super.initState();
    // Refresh referral history provider once when widget is initialized
    Future.microtask(() => ref.refresh(refferralHistoryProvider));
  }

  void _copyReferralCode(BuildContext context, String code) {
    Clipboard.setData(ClipboardData(text: code));
    showGrowkSnackBar(
      context: context,
      ref: ref,
      message: "Referral code copied!",
      type: SnackType.success,
    );
  }

  void _shareReferralCode(String code) {
    Share.share("Use my GrowK referral code $code and earn gold!");
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final historyAsync = ref.watch(refferralHistoryProvider);

    return Scaffold(
      backgroundColor: AppColors.current(isDark).scaffoldBackground,
      appBar: const GrowkAppBar(
        title: "My Referral Rewards",
        isBackBtnNeeded: true,
      ),
      body: ScalingFactor(
        child: historyAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text("Error: $err")),
          data: (historyData) {
            final referralCode = historyData.data?.referralCode ?? 'Update KYC';
            final totalGold =
                double.parse(historyData.data?.totalReward ?? '0.000')
                    .toStringAsFixed(3);
            final referralHistory = historyData.data?.referralHistory ?? [];

            return GrowkRefreshIndicator(
              providerToRefresh: refferralHistoryProvider,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableWhiteContainerWithPadding(
                      widget: ReusableColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Referral Rewards",
                              style: AppTextStyle.current(isDark).bodyKycSmall),
                          const SizedBox(height: 4),
                          Text("$totalGold g",
                              style: AppTextStyle.current(isDark).headlineLarge),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(AppImages.referralDark,
                                    height: 36),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Share & Earn Gold",
                                        style:  AppTextStyle.current(isDark).titleSmall),
                                    SizedBox(height: 4),
                                    Text(
                                      "Invite friends to GrowK and earn rewards! Share your referral code—get gold worth 10 SAR when they complete their first transaction!",
                                      style:  AppTextStyle.current(isDark).bodyKycSmall,
                                    ),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: isDark?Colors.white:Colors.black,
                                  ),
                                  child: Text(referralCode,
                                      style: AppTextStyle.current(isDark).titleSmall.copyWith(color: isDark?Colors.black:Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () =>
                                    _copyReferralCode(context, referralCode),
                                child: Icon(Icons.copy_rounded,color: AppColors.current(isDark).text,),
                              ),
                              const SizedBox(width: 10),
                              InkWell(
                                onTap: () => _shareReferralCode(referralCode),
                                child: Icon(Icons.share_rounded,color: AppColors.current(isDark).text,),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Text(
                            "You will receive gold worth 10 SAR only after the referred user successfully completes their first transaction. Referral rewards are subject to change and are governed by GrowK's terms and conditions.",
                            textAlign: TextAlign.justify,
                            style:  AppTextStyle.current(isDark).bodyKycSmall,
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    ReusableWhiteContainerWithPadding(
                      widget: ReusableColumn(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("2025", style:  AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontWeight: FontWeight.normal,fontSize: 13)),
                          const SizedBox(height: 4),
                          Text("Reward History",
                              style:  AppTextStyle.current(isDark).titleSmall),
                          const SizedBox(height: 10),
                          if (referralHistory.isEmpty)
                            Text("No rewards yet.",
                                style:  AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontWeight: FontWeight.normal,fontSize: 13))
                          else
                            ...referralHistory.map((reward) {
                              ImageProvider? avatar;
                              if (reward.proPic != null &&
                                  reward.proPic!.isNotEmpty) {
                                try {
                                  avatar =
                                      MemoryImage(base64Decode(reward.proPic!));
                                } catch (_) {
                                  avatar = const AssetImage(
                                      AppImages.profileDefaultImage);
                                }
                              } else {
                                avatar = const AssetImage(
                                    AppImages.profileDefaultImage);
                              }

                              String? formattedDate = reward.appliedDate;
                              try {
                                final dt = DateTime.parse(reward.appliedDate!);
                                formattedDate =
                                    "${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}";
                              } catch (_) {}

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: avatar,
                                      radius: 20,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(reward.userName ?? '',
                                              style: AppTextStyle.current(isDark).titleSmall),
                                          const SizedBox(height: 2),
                                          Text(
                                            "Your referral reward has been credited successfully!",
                                            style:  AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontWeight: FontWeight.normal,fontSize: 13),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(formattedDate!,
                                              style:  AppTextStyle.current(isDark).bodyKycSmall.copyWith(fontWeight: FontWeight.normal,fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                    Text("${reward.goldAmount} g",
                                        style:  AppTextStyle.current(isDark).titleSmall),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
