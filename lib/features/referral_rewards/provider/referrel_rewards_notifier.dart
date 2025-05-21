import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/referral_rewards/model/referrel_rewards_model.dart';

class ReferralRewardsNotifier extends StateNotifier<List<ReferralReward>> {
  ReferralRewardsNotifier()
      : super([
          ReferralReward(
            name: "Zayd Al-Faris",
            avatarUrl: "assets/profile1.jpg",
            dateTime: "22 February 15:30 PM",
            goldReceived: "0.0269",
          ),
          ReferralReward(
            name: "Omar Al-Hakim",
            avatarUrl: "assets/profile2.jpg",
            dateTime: "22 February 15:30 PM",
            goldReceived: "0.0276",
          ),
          ReferralReward(
            name: "Kareem Al-Rashid",
            avatarUrl: "assets/profile3.jpg",
            dateTime: "22 February 15:30 PM",
            goldReceived: "0.0257",
          ),
          ReferralReward(
            name: "Rayan Al-Mansoor",
            avatarUrl: "assets/profile4.jpg",
            dateTime: "22 February 15:30 PM",
            goldReceived: "0.0263",
          ),
          ReferralReward(
            name: "Yusuf Al-Amin",
            avatarUrl: "assets/profile5.jpg",
            dateTime: "22 February 15:30 PM",
            goldReceived: "0.0259",
          ),
        ]);

  void addReward(ReferralReward reward) {
    state = [...state, reward];
  }

  void clearRewards() {
    state = [];
  }
}

final referralRewardsProvider =
    StateNotifierProvider<ReferralRewardsNotifier, List<ReferralReward>>(
  (ref) => ReferralRewardsNotifier(),
);
