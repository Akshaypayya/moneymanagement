import 'package:growk_v2/features/referral_rewards/model/refferral_history_model.dart';

import '../../../views.dart';

class RefferralHistoryRepo {
  final NetworkService network;

  RefferralHistoryRepo(this.network);

  Future<RefferralHistoryModel> getRefferralHistory() async {
    final json = await network.get(
      AppUrl.getRefferalHistoryUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
    );
    return RefferralHistoryModel.fromJson(json);
  }
}
