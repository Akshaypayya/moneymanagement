import 'package:growk_v2/views.dart';

/// HomeController to manage the business logic
class HomeController {
  final GetHomeDetailsUseCase useCase;

  HomeController(this.useCase);

  Future<GetHomeDetailsModel> fetchHomeDetails() async {
    return await useCase();
  }
}
