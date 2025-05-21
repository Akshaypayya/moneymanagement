import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/features/bank_details/model/bank_response_model.dart';

class BankOtpRepo {
  final NetworkService network;

  BankOtpRepo(this.network);

  Future<BankResponse> submitBankOtp(
      String otp, Map<String, String> data) async {
    final urlWithOtp = '${AppUrl.bankOtp}/$otp';

    final json = await network.post(
      urlWithOtp,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: data,
    );

    return BankResponse.fromJson(json);
  }
}
