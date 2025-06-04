import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/model/sell_gold_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/sell_gold_repo.dart';
import 'package:growk_v2/views.dart';

// ✅ SellGold Use Case
class SellGoldUseCase {
  final SellGoldRepo repo;
  SellGoldUseCase(this.repo);

  Future<SellGoldModel> call(double goldQuantity, String transactionId) async {
    return await repo.sellGold(goldQuantity, transactionId);
  }
}

