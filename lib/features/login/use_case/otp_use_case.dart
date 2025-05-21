import 'package:money_mangmnt/features/login/model/otp_model.dart';

import '../repo/otp_repo.dart';

class OtpUseCase {
  final OtpRepository repo;

  OtpUseCase(this.repo);

  Future<OtpResponse> call(String cellNo, String otpNum) {
    return repo.verifyOtp(cellNo, otpNum);
  }
}
