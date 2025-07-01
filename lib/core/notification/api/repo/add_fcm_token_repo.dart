import 'package:growk_v2/core/notification/api/models/add_fcm_token_model.dart';

import '../../../../views.dart';

class AddFcmTokenRepo {
  final NetworkService network;

  AddFcmTokenRepo(this.network);

  Future<AddFcmTokenModel> addFcmToken(String fcmToken) async {
    final json = await network.put(
      AppUrl.addFcmTokenUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: {
        "fcmToken": fcmToken
      },
    );

    return AddFcmTokenModel.fromJson(json);
  }
}
