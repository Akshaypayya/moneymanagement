import 'package:growk_v2/features/buy_gold_instantly/view/model/initiate_buy_gold_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/initiate_buy_gold_model_notifier.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/buy_gold_repo.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/initiate_gold_buy_repo.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/repo/live_gold_price_repo.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/use_case/buy_gold_use_case.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/use_case/initiate_buy_gold_use_case.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/use_case/live_gold_price_use_case.dart';
import '../../../../views.dart';

final initiateGoldBuyRepoProvider = Provider<InitiateGoldBuyRepo>((ref) {
  final network = NetworkService(client: createUnsafeClient(), baseUrl: AppUrl.baseUrl);
  return InitiateGoldBuyRepo(network);
});

final initiateGoldBuyUseCaseProvider = Provider<InitiateBuyGoldUseCase>((ref) {
  final repo = ref.read(initiateGoldBuyRepoProvider);
  return InitiateBuyGoldUseCase(repo);
});
final initiateBuyGoldProvider = StateNotifierProvider<InitiateBuyGoldNotifier, InitiateBuyGoldModel?>(
      (ref) => InitiateBuyGoldNotifier(),
);

///buy gold
final goldBuyRepoProvider = Provider<BuyGoldRepo>((ref) {
  final network = NetworkService(client: createUnsafeClient(), baseUrl: AppUrl.baseUrl);
  return BuyGoldRepo(network);
});

final goldBuyUseCaseProvider = Provider<BuyGoldUseCase>((ref) {
  final repo = ref.read(goldBuyRepoProvider);
  return BuyGoldUseCase(repo);
});
final liveGoldPriceRepoProvider = Provider<GetLiveGoldPriceRepo>((ref) {
  return GetLiveGoldPriceRepo(NetworkService(client: createUnsafeClient(), baseUrl: AppUrl.baseUrl));
});

final liveGoldPriceUseCaseProvider = Provider<GetLiveGoldPriceUseCase>((ref) {
  final repo = ref.watch(liveGoldPriceRepoProvider);
  return GetLiveGoldPriceUseCase(repo);
});
