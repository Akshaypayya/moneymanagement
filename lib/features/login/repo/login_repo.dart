import 'package:money_mangmnt/core/constants/app_url.dart';

import '../../../core/network/network_service.dart';
import '../model/login_model.dart';

class LoginRepository {
  final NetworkService network;

  LoginRepository(this.network);

  Future<LoginResponse> loginUser(String cellNo) async {
    final json = await network.post(
      AppUrl.loginUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: {'cellNo': cellNo},
    );

    return LoginResponse.fromJson(json);
  }
}
