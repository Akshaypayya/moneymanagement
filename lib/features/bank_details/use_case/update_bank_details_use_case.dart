import 'package:money_mangmnt/features/bank_details/model/bank_response_model.dart';
import 'package:money_mangmnt/features/bank_details/repo/update_bank_details_repo.dart';

class UpdateBankUseCase {
  final UpdateBankRepository repo;

  UpdateBankUseCase(this.repo);

  Future<BankResponse> call(Map<String, String> data) {
    return repo.submitBankDetails(data);
  }
}
