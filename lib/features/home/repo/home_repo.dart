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
    return GetHomeDetailsModel.fromJson(json);
  }
}
