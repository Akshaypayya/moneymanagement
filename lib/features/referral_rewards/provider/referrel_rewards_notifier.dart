import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/referral_rewards/model/referrel_rewards_model.dart';
import 'package:growk_v2/features/referral_rewards/model/refferral_history_model.dart';
import 'package:growk_v2/features/referral_rewards/repo/refferal_history_repo.dart';
import 'package:growk_v2/features/referral_rewards/use_case/refferral_history_use_case.dart';

import '../../profile_page/provider/user_details_provider.dart';

class ReferralRewardsNotifier extends StateNotifier<List<ReferralReward>> {
  ReferralRewardsNotifier() : super([
    // ReferralReward(
    //   name: "Zayd Al-Faris",
    //   avatarUrl: "assets/profile1.jpg",
    //   dateTime: "22 February 15:30 PM",
    //   goldReceived: "0.0269",
    // ),
    // ReferralReward(
    //   name: "Omar Al-Hakim",
    //   avatarUrl: "assets/profile2.jpg",
    //   dateTime: "22 February 15:30 PM",
    //   goldReceived: "0.0276",
    // ),
    // ReferralReward(
    //   name: "Kareem Al-Rashid",
    //   avatarUrl: "assets/profile3.jpg",
    //   dateTime: "22 February 15:30 PM",
    //   goldReceived: "0.0257",
    // ),
    // ReferralReward(
    //   name: "Rayan Al-Mansoor",
    //   avatarUrl: "assets/profile4.jpg",
    //   dateTime: "22 February 15:30 PM",
    //   goldReceived: "0.0263",
    // ),
    // ReferralReward(
    //   name: "Yusuf Al-Amin",
    //   avatarUrl: "assets/profile5.jpg",
    //   dateTime: "22 February 15:30 PM",
    //   goldReceived: "0.0259",
    // ),
  ]);

  void addReward(ReferralReward reward) {
    state = [...state, reward];
  }

  void clearRewards() {
    state = [];
  }
}

final referralRewardsProvider = StateNotifierProvider<ReferralRewardsNotifier, List<ReferralReward>>(
      (ref) => ReferralRewardsNotifier(),
);
final refferralHistoryUseCaseProvider = Provider<RefferralHistoryUseCase>((ref) {
  final networkService = ref.watch(networkServiceProvider); // Assuming this exists
  return RefferralHistoryUseCase(RefferralHistoryRepo(networkService));
});
final refferralHistoryProvider = FutureProvider<RefferralHistoryModel>((ref) {
  final useCase = ref.watch(refferralHistoryUseCaseProvider);
  return useCase();
});
