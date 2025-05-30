import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/apply_referal_code/model/apply_ref_code_model.dart';
import 'package:growk_v2/features/login/model/otp_model.dart';
import 'package:growk_v2/features/wallet_page/model/load_wallet_amount_model.dart';
import '../../../core/network/network_service.dart';
import '../../../views.dart';
class LoadWalletAmountRepo {
  final NetworkService network;
  LoadWalletAmountRepo(this.network);

  Future<LoadWalletAmountModel> loadWalletAmount(String virtualAccount, int amount) async {
    final cleanedVirtualAccount = virtualAccount.trim();
    final cleanedAmount = amount;
    final headers = {
      'Content-Type': 'application/json',
      'app': 'SA',
    };
    final payload = {
      "virtualAccount": cleanedVirtualAccount,
      "amount": cleanedAmount,
    };

    debugPrint('Headers: $headers');
    debugPrint('Payload: $payload');
    final response = await network.post(
      AppUrl.loadAmountToWallet,
      headers: headers,
      body: payload,
    );
    return LoadWalletAmountModel.fromJson(response);
  }
}
