import 'package:growk_v2/features/saved_address/model/saved_adddress_model.dart';
import 'package:growk_v2/features/saved_address/repo/saved_address_repo.dart';


class SavedAddressUseCase {
  final SavedAddressRepo repo;

  SavedAddressUseCase(this.repo);

  Future<SavedAdddressModel> call(Map<String, String> data) {
    return repo.submitSavedAddress(data);
  }
}
