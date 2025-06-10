import 'package:growk_v2/features/buy_gold_instantly/view/model/initiate_buy_gold_model.dart';
import '../../../../views.dart';

class InitiateGoldBuyRepo {
  final NetworkService network;
  InitiateGoldBuyRepo(this.network);

  Future<InitiateBuyGoldModel> initiateBuyGold(
      double amount, int operation) async {
    final cleanedAmount = amount;
    final headers = {
      'Content-Type': 'application/json',
      'app': 'SA',
    };
    final payload = {
      "transactionAmount": cleanedAmount,
      "operation": operation
    };

    debugPrint('Headers: $headers');
    debugPrint('Payload: $payload');
    final response = await network.post(
      AppUrl.initiateGoldBuyUrl,
      headers: headers,
      body: payload,
    );
    return InitiateBuyGoldModel.fromJson(response);
  }
}
