import 'package:growk_v2/features/add_user_details/model/update_user_details_model.dart';
import '../../../views.dart';
class UpdateUserDetailsRepo {
  final NetworkService network;

  UpdateUserDetailsRepo(this.network);

  Future<UpdateUserDetailsModel> updateUserDetails({
    required String userName,
    required String emailId,
    required String dob,
    required String gender,
  }) async {
    final json = await network.put(
      AppUrl.updateUserDetailsUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: {
        "userName": userName,
        "emailId": emailId,
        "dob": dob,
        "gender": gender,
      },
    );

    return UpdateUserDetailsModel.fromJson(json);
  }
}
