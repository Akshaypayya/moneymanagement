import 'package:growk_v2/core/notification/api/models/add_fcm_token_model.dart';
import 'package:growk_v2/core/notification/api/repo/add_fcm_token_repo.dart';

class AddFcmTokenUseCase {
  final AddFcmTokenRepo repo;

  AddFcmTokenUseCase(this.repo);

  Future<AddFcmTokenModel> call(String fcmToken) {
    return repo.addFcmToken(fcmToken);
  }
}
