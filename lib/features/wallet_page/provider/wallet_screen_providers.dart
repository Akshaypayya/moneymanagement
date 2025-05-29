import 'package:money_mangmnt/features/wallet_page/model/get_wallet_balance_model.dart';
import 'package:money_mangmnt/features/wallet_page/provider/load_wallet_amount_notifier.dart';
import 'package:money_mangmnt/features/wallet_page/repo/get_wallet_balance_repo.dart';
import 'package:money_mangmnt/features/wallet_page/repo/load_wallet_amount_repo.dart';
import 'package:money_mangmnt/features/wallet_page/use_case/get_wallet_balance_use_case.dart';
import 'package:money_mangmnt/features/wallet_page/use_case/load_wallet_amount_use_case.dart';

import '../../../views.dart';

final getWalletBalanceRepoProvider = Provider<GetWalletBalanceRepo>((ref) {
  final network = ref.watch(networkServiceProvider);
  return GetWalletBalanceRepo(network);
});
final getWalletBalanceUseCaseProvider =
    Provider<GetWalletBalanceUseCase>((ref) {
  final repo = ref.watch(getWalletBalanceRepoProvider);
  return GetWalletBalanceUseCase(repo);
});
final walletBalanceProvider =
    FutureProvider<GetWalletBalanceModel>((ref) async {
  final useCase = ref.watch(getWalletBalanceUseCaseProvider);
  return useCase(); // calls the Future<GetWalletBalanceModel> call()
});

//fetching provider
final getNewWalletBalanceProvider =
    FutureProvider<GetWalletBalanceModel>((ref) async {
  final network =
      NetworkService(client: createUnsafeClient(), baseUrl: AppUrl.baseUrl);
  final repo = GetWalletBalanceRepo(network);
  final useCase = GetWalletBalanceUseCase(repo);
  return await useCase();
});

//providers for load wallet amount
final loadWalletAmountRepoProvider = Provider<LoadWalletAmountRepo>((ref) {
  final network =
      NetworkService(client: createUnsafeClient(), baseUrl: AppUrl.baseUrl);
  return LoadWalletAmountRepo(network);
});

final loadWalletAmountUseCaseProvider =
    Provider<LoadWalletAmountUseCase>((ref) {
  final repo = ref.read(loadWalletAmountRepoProvider);
  return LoadWalletAmountUseCase(repo);
});

final loadWalletAmountNotifierProvider =
    StateNotifierProvider<LoadWalletAmountNotifier, LoadWalletAmountState>(
        (ref) {
  final useCase = ref.read(loadWalletAmountUseCaseProvider);
  return LoadWalletAmountNotifier(useCase);
});
