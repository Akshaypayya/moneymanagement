import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/goals/goal_detail_page/repo/sell_gold_repo.dart';

final sellGoldRepositoryProvider = Provider<SellGoldRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return SellGoldRepository(networkService, ref);
});

final isSellGoldLoadingProvider = StateProvider<bool>((ref) => false);
