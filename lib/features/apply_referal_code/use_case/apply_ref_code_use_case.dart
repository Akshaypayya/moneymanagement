import 'package:money_mangmnt/features/apply_referal_code/model/apply_ref_code_model.dart';
import 'package:money_mangmnt/features/apply_referal_code/repo/apply_ref_code_repo.dart';

class ApplyRefCodeUseCase {
  final ApplyRefCodeRepo repo;

  ApplyRefCodeUseCase(this.repo);

  Future<ApplyRefCodeModel> call(String refCode) {
    return repo.verifyRefCode(refCode);
  }
}
