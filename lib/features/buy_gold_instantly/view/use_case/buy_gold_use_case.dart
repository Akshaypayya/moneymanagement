import 'package:growk_v2/features/buy_gold_instantly/view/model/buy_gold_model.dart';
import '../repo/buy_gold_repo.dart';

class BuyGoldUseCase {
  final BuyGoldRepo repo;

  BuyGoldUseCase(this.repo);

  Future<BuyGoldModel> call(double debitAmount,String transactionId) {
    return repo.buyGold(debitAmount,transactionId);
  }
}
