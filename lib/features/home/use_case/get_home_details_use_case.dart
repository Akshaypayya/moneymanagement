import '../../../views.dart';
class GetHomeDetailsUseCase {
  final GetHomeDetailsRepo repo;

  GetHomeDetailsUseCase(this.repo);

  Future<GetHomeDetailsModel> call() {
    return repo.getHomeDetails();
  }
}
