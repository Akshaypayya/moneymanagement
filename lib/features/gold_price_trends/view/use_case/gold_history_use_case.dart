import 'package:growk_v2/features/gold_price_trends/view/model/gold_history_model.dart';
import 'package:growk_v2/features/gold_price_trends/view/repo/gold_history_repo.dart';

class GoldHistoryUseCase {
  final GetGoldHistoryRepo repo;
  final String timing;

  GoldHistoryUseCase(this.repo,this.timing);

  Future<GoldHistoryModel> call() {
    return repo.getGoldHistory(timing);
  }
}
