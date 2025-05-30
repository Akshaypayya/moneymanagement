import 'package:growk_v2/features/wallet_page/model/load_wallet_amount_model.dart';
import 'package:growk_v2/features/wallet_page/use_case/load_wallet_amount_use_case.dart';

import '../../../views.dart';

class LoadWalletAmountNotifier extends StateNotifier<LoadWalletAmountState> {
  final LoadWalletAmountUseCase useCase;

  LoadWalletAmountNotifier(this.useCase) : super(const LoadWalletAmountState());

  Future<void> loadAmount(String virtualAccount, int amount) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await useCase(virtualAccount, amount);
      state = state.copyWith(data: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}


@immutable
class LoadWalletAmountState {
  final bool isLoading;
  final LoadWalletAmountModel? data;
  final String? error;

  const LoadWalletAmountState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  LoadWalletAmountState copyWith({
    bool? isLoading,
    LoadWalletAmountModel? data,
    String? error,
  }) {
    return LoadWalletAmountState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

