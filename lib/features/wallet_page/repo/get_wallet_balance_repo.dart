import 'package:growk_v2/features/referral_rewards/model/refferral_history_model.dart';
import 'package:growk_v2/features/wallet_page/model/get_wallet_balance_model.dart';

import '../../../views.dart';

class GetWalletBalanceRepo {
  final NetworkService network;

  GetWalletBalanceRepo(this.network);

  Future<GetWalletBalanceModel> getWalletBalance() async {
    final json = await network.get(
      AppUrl.getWalletBalance,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
    );
    return GetWalletBalanceModel.fromJson(json);
  }
}
