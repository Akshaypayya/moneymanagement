import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/features/bank_details/model/bank_response_model.dart';
import 'package:money_mangmnt/features/nominee_details/model/nominee_model.dart';

class NomineeRepo {
  final NetworkService network;

  NomineeRepo(this.network);

  Future<NomineeDetailsModel> submitNomineeDetails(
      Map<String, String> data) async {
    final json = await network.post(
      AppUrl.nomineeDetailsUrl,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
      body: data,
    );

    return NomineeDetailsModel.fromJson(json);
  }
}
