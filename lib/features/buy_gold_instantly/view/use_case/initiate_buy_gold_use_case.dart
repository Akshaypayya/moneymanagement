import 'package:growk_v2/features/buy_gold_instantly/view/model/initiate_buy_gold_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/initiate_gold_buy_repo.dart';

class InitiateBuyGoldUseCase {
  final InitiateGoldBuyRepo repo;

  InitiateBuyGoldUseCase(this.repo);

  Future<InitiateBuyGoldModel> call(double amount) {
    return repo.initiateBuyGold(amount);
  }
}
