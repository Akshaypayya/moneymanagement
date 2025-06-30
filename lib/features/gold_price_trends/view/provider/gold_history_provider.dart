

// Provider that fetches gold history based on duration like '1Y', '6M', etc.
import 'package:growk_v2/features/gold_price_trends/view/model/gold_history_model.dart';
import 'package:growk_v2/features/gold_price_trends/view/repo/gold_history_repo.dart';
import 'package:growk_v2/features/gold_price_trends/view/use_case/gold_history_use_case.dart';

import '../../../../views.dart';

final goldHistoryProvider = FutureProvider.family<GoldHistoryModel, String>((ref, duration) async {
  final networkService = ref.read(networkServiceProvider);
  final repo = GetGoldHistoryRepo(networkService);
  final useCase = GoldHistoryUseCase(repo, duration);
  final result = await useCase.call();

  if (result.status?.toLowerCase() == 'failed') {
    throw Exception('API status failed');
  }

  return result;
});
final selectedPeriodProvider = StateProvider<String>((ref) => '1M');
final investmentAmountProvider = StateProvider<double>((ref) => 150000);
final lastChartSpotsProvider = StateProvider<List<FlSpot>>((ref) => []);

final goldHistorySpotsProvider = FutureProvider<List<FlSpot>>((ref) async {
  final networkService = ref.read(networkServiceProvider);
  final selectedPeriod = ref.watch(selectedPeriodProvider);

  final repo = GetGoldHistoryRepo(networkService);
  final useCase = GoldHistoryUseCase(repo, selectedPeriod);
  final data = await useCase.call();

  if (data.status?.toLowerCase() != 'success') return [];

  final aaData = data.data?.aaData ?? [];
  final chartSpots = aaData
      .asMap()
      .entries
      .map(
        (entry) =>
        FlSpot(entry.key.toDouble(), entry.value.buyRate?.toDouble() ?? 0),
  )
      .toList();

  ref.read(lastChartSpotsProvider.notifier).state = chartSpots;
  return chartSpots;
});
