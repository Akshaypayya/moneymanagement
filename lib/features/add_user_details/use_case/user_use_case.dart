import 'package:growk_v2/features/add_user_details/model/update_user_details_model.dart';

import '../../../views.dart';

class UpdateUserUseCase {
  final UpdateUserDetailsRepo repo;

  UpdateUserUseCase(this.repo);

  Future<UpdateUserDetailsModel> call({
    required String userName,
    required String emailId,
    required String dob,
    required String gender,
  }) {
    return repo.updateUserDetails(
      userName: userName,
      emailId: emailId,
      dob: dob,
      gender: gender,
    );
  }
}
