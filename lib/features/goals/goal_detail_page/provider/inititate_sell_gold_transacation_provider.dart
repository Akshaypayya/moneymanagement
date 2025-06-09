import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/initiate_gold_sell_transaction_model.dart';
import 'package:growk_v2/features/goals/goal_detail_page/repo/inititate_gold_sell_repo.dart';

final initiateSellGoldRepositoryProvider =
    Provider<InitiateSellGoldRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return InitiateSellGoldRepository(networkService, ref);
});

final isInitiateSellGoldLoadingProvider = StateProvider<bool>((ref) => false);

final initiateSellGoldDataProvider =
    StateProvider<InitiateSellGoldData?>((ref) => null);
