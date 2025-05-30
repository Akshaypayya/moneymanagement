
import 'package:growk_v2/features/buy_gold_instantly/view/model/live_gold_price_model.dart';

import '../../../../views.dart';

class GetLiveGoldPriceRepo {
  final NetworkService network;

  GetLiveGoldPriceRepo(this.network);

  Future<LiveGoldPriceModel> getLiveGoldPrice() async {
    final json = await network.get(
      AppUrl.getLiveGoldPriceUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
    );
    return LiveGoldPriceModel.fromJson(json);
  }
}
