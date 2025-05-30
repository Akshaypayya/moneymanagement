import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/login/model/otp_model.dart';
import '../../../core/network/network_service.dart';

class OtpRepository {
  final NetworkService network;
  OtpRepository(this.network);

  Future<OtpResponse> verifyOtp(String cellNo, String otpNum) async {
    final cleanedCellNo = cellNo.trim();

    final headers = {
      'Content-Type': 'application/json',
      'app': 'SA',
    };

    final body = {
      'cellNo': cleanedCellNo,
      'otpNum': otpNum,
    };

    print('OTP Request:');
    print('URL: ${AppUrl.baseUrl}${AppUrl.otpUrl}');
    print('Headers: $headers');
    print('Body: $body');

    final response = await network.post(
      AppUrl.otpUrl,
      headers: headers,
      body: body,
    );

    return OtpResponse.fromJson(response);
  }
}
