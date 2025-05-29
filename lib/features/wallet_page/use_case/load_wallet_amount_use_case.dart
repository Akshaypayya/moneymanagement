import 'package:money_mangmnt/features/apply_referal_code/model/apply_ref_code_model.dart';
import 'package:money_mangmnt/features/apply_referal_code/repo/apply_ref_code_repo.dart';
import 'package:money_mangmnt/features/wallet_page/model/load_wallet_amount_model.dart';
import 'package:money_mangmnt/features/wallet_page/repo/load_wallet_amount_repo.dart';

class LoadWalletAmountUseCase {
  final LoadWalletAmountRepo repo;

  LoadWalletAmountUseCase(this.repo);

  Future<LoadWalletAmountModel> call(String virtualAccount, int amount) {
    return repo.loadWalletAmount(virtualAccount, amount);
  }
}
