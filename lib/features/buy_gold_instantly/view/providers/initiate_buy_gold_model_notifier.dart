import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/model/initiate_buy_gold_model.dart';

class InitiateBuyGoldNotifier extends StateNotifier<InitiateBuyGoldModel?> {
  InitiateBuyGoldNotifier() : super(null);

  void setTransaction(InitiateBuyGoldModel model) {
    state = model;
  }

  void clearTransaction() {
    state = null;
  }
}
