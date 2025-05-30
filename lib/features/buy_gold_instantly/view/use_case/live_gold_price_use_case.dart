import 'package:growk_v2/features/buy_gold_instantly/view/model/live_gold_price_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/live_gold_price_repo.dart';

class GetLiveGoldPriceUseCase {
  final GetLiveGoldPriceRepo repo;

  GetLiveGoldPriceUseCase(this.repo);

  Future<LiveGoldPriceModel> call() {
    return repo.getLiveGoldPrice();
  }
}
