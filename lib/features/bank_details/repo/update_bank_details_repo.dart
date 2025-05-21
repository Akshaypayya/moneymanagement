import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/features/bank_details/model/bank_response_model.dart';

class UpdateBankRepository {
  final NetworkService network;

  UpdateBankRepository(this.network);

  Future<BankResponse> submitBankDetails(Map<String, String> data) async {
    final json = await network.post(
      AppUrl.updateBankDetailsUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: data,
    );

    return BankResponse.fromJson(json);
  }
}
