import 'package:growk_v2/features/referral_rewards/model/refferral_history_model.dart';
import 'package:growk_v2/features/referral_rewards/repo/refferal_history_repo.dart';

class RefferralHistoryUseCase {
  final RefferralHistoryRepo repo;

  RefferralHistoryUseCase(this.repo);

  Future<RefferralHistoryModel> call() {
    return repo.getRefferralHistory();
  }
}
