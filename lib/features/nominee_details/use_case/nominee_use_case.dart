import 'package:growk_v2/features/nominee_details/model/nominee_model.dart';
import 'package:growk_v2/features/nominee_details/repo/nominee_repo.dart';


class NomineeUseCase {
  final NomineeRepo repo;

  NomineeUseCase(this.repo);

  Future<NomineeDetailsModel> call(Map<String, String> data) {
    return repo.submitNomineeDetails(data);
  }
}
