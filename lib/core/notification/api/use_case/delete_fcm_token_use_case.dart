import 'package:growk_v2/core/notification/api/models/delete_fcm_token_model.dart';
import 'package:growk_v2/core/notification/api/repo/delete_fcm_token_repo.dart';

class DeleteFcmTokenUseCase {
  final DeleteFcmTokenRepo repo;

  DeleteFcmTokenUseCase(this.repo);

  Future<DeleteFcmTokenModel> call() {
    return repo.deleteFcmToken();
  }
}


