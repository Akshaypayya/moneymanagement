import 'package:growk_v2/features/buy_gold_instantly/view/model/sell_gold_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/sell_gold_repo.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/use_case/sell_gold_use_case.dart';

import '../../../../views.dart';

final sellGoldRepoProvider = Provider<SellGoldRepo>((ref) {
  final network = ref.watch(networkServiceProvider);
  return SellGoldRepo(network);
});

// ✅ Provider for Use Case
final goldSellUseCaseProvider = Provider<SellGoldUseCase>((ref) {
  final network = ref.read(networkServiceProvider);
  final repo = SellGoldRepo(network);
  return SellGoldUseCase(repo);
});
