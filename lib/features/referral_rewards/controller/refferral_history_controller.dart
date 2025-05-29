// referral_rewards_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/referral_rewards/model/referrel_rewards_model.dart';
import 'package:growk_v2/features/referral_rewards/provider/referrel_rewards_notifier.dart';
import 'package:growk_v2/features/referral_rewards/use_case/refferral_history_use_case.dart';

final referralRewardsControllerProvider = Provider<ReferralRewardsController>((ref) {
  final useCase = ref.read(refferralHistoryUseCaseProvider);
  final notifier = ref.read(referralRewardsProvider.notifier);
  return ReferralRewardsController(useCase, notifier);
});

class ReferralRewardsController {
  final RefferralHistoryUseCase useCase;
  final ReferralRewardsNotifier notifier;

  ReferralRewardsController(this.useCase, this.notifier);

  Future<void> loadReferralRewards() async {
    try {
      final history = await useCase();
      notifier.clearRewards();

      final rewards = history.data?.referralHistory ?? [];
      for (final reward in rewards) {
        notifier.addReward(
          ReferralReward(
            name: reward.userName?.isNotEmpty == true ? reward.userName! : "Unnamed User",
            avatarUrl: reward.proPic?.isNotEmpty == true ? reward.proPic! : "assets/default_avatar.png",
            dateTime: reward.appliedDate ?? "Unknown Date",
            goldReceived: reward.goldAmount != null
                ? reward.goldAmount!.toStringAsFixed(3)
                : "0.000",
          ),
        );
      }
    } catch (e, stackTrace) {
      // Log error with stack trace for better debugging
      print("Failed to load referral rewards: $e");
      print(stackTrace);
    }
  }
}
