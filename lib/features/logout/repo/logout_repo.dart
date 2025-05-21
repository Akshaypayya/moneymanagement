import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/logout/model/logout_model.dart';
import '../../../core/network/network_service.dart';

class LogoutRepository {
  final NetworkService network;

  LogoutRepository(this.network);

  Future<LogoutModel> logoutUser(
      String refreshToken, String accessToken) async {
    final json = await network.post(
      AppUrl.logoutUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
        'Authorization': 'Bearer $accessToken',
      },
      body: {'refreshToken': refreshToken},
    );

    print('Logout Response: $json');
    return LogoutModel.fromJson(json);
  }
}
