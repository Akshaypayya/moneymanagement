import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/apply_referal_code/model/apply_ref_code_model.dart';
import 'package:money_mangmnt/features/login/model/otp_model.dart';
import '../../../core/network/network_service.dart';

class ApplyRefCodeRepo {
  final NetworkService network;
  ApplyRefCodeRepo(this.network);

  Future<ApplyRefCodeModel> verifyRefCode(String refCode) async {
    final cleanedRefCode = refCode.trim();

    final headers = {
      'Content-Type': 'application/json',
      'app': 'SA',
    };

    print('📤 OTP Request:');
    print('URL: ${AppUrl.baseUrl}${AppUrl.otpUrl}');
    print('Headers: $headers');

    final response = await network.post(
      "${AppUrl.applyRefCodeUrl}/$cleanedRefCode",
      headers: headers,
      body: {},
    );

    return ApplyRefCodeModel.fromJson(response);
  }
}
