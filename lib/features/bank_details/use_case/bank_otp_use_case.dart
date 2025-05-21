// bank_otp_use_case.dart
import 'package:money_mangmnt/features/bank_details/model/bank_response_model.dart';
import '../repo/bank_otp_repo.dart';

class BankOtpUseCase {
  final BankOtpRepo repo;
  BankOtpUseCase(this.repo);

  Future<BankResponse> call(String otp, Map<String, String> data) {
    return repo.submitBankOtp(otp, data);
  }
}
