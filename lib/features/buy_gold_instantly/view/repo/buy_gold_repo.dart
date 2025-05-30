import 'package:growk_v2/features/buy_gold_instantly/view/model/buy_gold_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/model/initiate_buy_gold_model.dart';
import '../../../../views.dart';

class BuyGoldRepo {
  final NetworkService network;
  BuyGoldRepo(this.network);

  Future<BuyGoldModel> buyGold(double debitAmount,String transactionId) async {
    final cleanedDebitAmount = debitAmount;
    final cleanedTransactionId = transactionId.trim();
    final headers = {
      'Content-Type': 'application/json',
      'app': 'SA',
    };
    final payload = {
      "debitAmount": cleanedDebitAmount,
      "transactionId":cleanedTransactionId
    };

    debugPrint('Headers: $headers');
    debugPrint('Payload: $payload');
    final response = await network.post(
      AppUrl.buyGoldUrl,
      headers: headers,
      body: payload,
    );
    return BuyGoldModel.fromJson(response);
  }
}
