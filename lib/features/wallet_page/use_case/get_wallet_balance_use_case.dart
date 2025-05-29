import 'package:money_mangmnt/features/referral_rewards/model/refferral_history_model.dart';
import 'package:money_mangmnt/features/referral_rewards/repo/refferal_history_repo.dart';
import 'package:money_mangmnt/features/wallet_page/model/get_wallet_balance_model.dart';
import 'package:money_mangmnt/features/wallet_page/repo/get_wallet_balance_repo.dart';

class GetWalletBalanceUseCase {
  final GetWalletBalanceRepo repo;

  GetWalletBalanceUseCase(this.repo);

  Future<GetWalletBalanceModel> call() {
    return repo.getWalletBalance();
  }
}
