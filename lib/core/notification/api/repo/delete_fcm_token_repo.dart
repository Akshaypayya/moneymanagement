import 'package:growk_v2/core/notification/api/models/add_fcm_token_model.dart';
import 'package:growk_v2/core/notification/api/models/delete_fcm_token_model.dart';

import '../../../../views.dart';

class DeleteFcmTokenRepo {
  final NetworkService network;

  DeleteFcmTokenRepo(this.network);

  Future<DeleteFcmTokenModel> deleteFcmToken() async {
    final json = await network.delete(
      AppUrl.deleteFcmTokenUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
    );

    return DeleteFcmTokenModel.fromJson(json);
  }
}
