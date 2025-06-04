import 'package:flutter/material.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/model/sell_gold_model.dart';
import 'package:growk_v2/views.dart';

class SellGoldRepo {
  final NetworkService network;
  SellGoldRepo(this.network);

  Future<SellGoldModel> sellGold(
      double goldQuantity, String transactionId) async {
    final cleanedQuantity = goldQuantity;
    final cleanedTransactionId = transactionId.trim();
    final headers = {
      'Content-Type': 'application/json',
      'app': 'SA',
    };
    final payload = {
      "gold": cleanedQuantity,
      "transactionId": cleanedTransactionId,
    };

    debugPrint('Sell Gold Headers: $headers');
    debugPrint('Sell Gold Payload: $payload');

    final response = await network.post(
      AppUrl.goalSellGoldUrl,
      headers: headers,
      body: payload,
    );
    return SellGoldModel.fromJson(response);
  }
}
