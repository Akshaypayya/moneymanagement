import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/features/saved_address/model/saved_adddress_model.dart';

class SavedAddressRepo {
  final NetworkService network;

  SavedAddressRepo(this.network);

  Future<SavedAdddressModel> submitSavedAddress(Map<String, String> data) async {
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
