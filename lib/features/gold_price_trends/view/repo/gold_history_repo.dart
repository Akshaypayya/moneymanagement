

import 'package:growk_v2/features/gold_price_trends/view/model/gold_history_model.dart';

import '../../../../views.dart';

class GetGoldHistoryRepo {
  final NetworkService network;

  GetGoldHistoryRepo(this.network);

  Future<GoldHistoryModel> getGoldHistory(String timing) async {
    final json = await network.get(
      '${AppUrl.getGoldHistoryUrl}$timing',
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
    );

    final model = GoldHistoryModel.fromJson(json);

    // // Throw exception if KYC not completed
    // if (model.status != 'Success') {
    //   throw Exception(model.message ?? 'KYC verification required');
    // }

    return model;
  }
}
