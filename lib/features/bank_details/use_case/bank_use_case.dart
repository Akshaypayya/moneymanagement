import 'package:growk_v2/features/bank_details/model/bank_response_model.dart';

import '../repo/bank_repo.dart';

class BankUseCase {
  final BankRepository repo;

  BankUseCase(this.repo);

  Future<BankResponse> call(Map<String, String> data) {
    return repo.submitBankDetails(data);
  }
}
