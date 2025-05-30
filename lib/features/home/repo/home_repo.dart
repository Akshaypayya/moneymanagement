
import '../../../views.dart';

class GetHomeDetailsRepo {
  final NetworkService network;

  GetHomeDetailsRepo(this.network);

  Future<GetHomeDetailsModel> getHomeDetails() async {
    final json = await network.get(
      AppUrl.getHomeDetails,
      headers: {
        'Content-Type': 'application/json',
        'app': 'SA',
      },
    );

    final model = GetHomeDetailsModel.fromJson(json);

    // Throw exception if KYC not completed
    if (model.status != 'Success') {
      throw Exception(model.message ?? 'KYC verification required');
    }

    return model;
  }
}
