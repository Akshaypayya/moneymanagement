import 'package:growk_v2/features/login/repo/login_repo.dart';

import '../model/login_model.dart';

class LoginUseCase {
  final LoginRepository repo;

  LoginUseCase(this.repo);

  Future<LoginResponse> call(String cellNo) {
    return repo.loginUser(cellNo);
  }
}
