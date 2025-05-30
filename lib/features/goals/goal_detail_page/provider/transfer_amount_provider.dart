import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/goals/goal_detail_page/repo/transfer_amount_repo.dart';

final transferAmountRepositoryProvider =
    Provider<TransferAmountRepository>((ref) {
  final networkService = NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
  return TransferAmountRepository(networkService, ref);
});
