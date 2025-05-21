import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/features/saved_address/model/saved_adddress_model.dart';

class SavedAddressRepo {
  final NetworkService network;

  SavedAddressRepo(this.network);

  Future<SavedAdddressModel> submitSavedAddress(
      Map<String, String> data) async {
    final json = await network.put(
      AppUrl.savedAddressUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: data,
    );

    return SavedAdddressModel.fromJson(json);
  }
}
