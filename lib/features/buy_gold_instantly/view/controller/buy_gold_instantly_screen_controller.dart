import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/model/live_gold_price_model.dart';
import 'package:growk_v2/features/buy_gold_instantly/view/providers/buy_gold_instantly_screen_providers.dart';

final liveGoldPriceProvider =
AsyncNotifierProvider.autoDispose<LiveGoldPriceNotifier, LiveGoldPriceModel>(
  LiveGoldPriceNotifier.new,
);

class LiveGoldPriceNotifier extends AutoDisposeAsyncNotifier<LiveGoldPriceModel> {
  Timer? _refreshTimer;

  @override
  Future<LiveGoldPriceModel> build() async {
    _startAutoRefresh();
    ref.onDispose(() {
      _refreshTimer?.cancel(); // Cancel timer when provider is disposed
    });

    return _fetchLivePrice();
  }

  Future<LiveGoldPriceModel> _fetchLivePrice() async {
    final useCase = ref.read(liveGoldPriceUseCaseProvider);
    return await useCase();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      final updatedPrice = await _fetchLivePrice();
      state = AsyncValue.data(updatedPrice);
    });
  }
}
