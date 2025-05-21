import 'dart:io';

import 'package:money_mangmnt/features/kyc_verification/repo/kyc_repo.dart';

class UploadKYCUseCase {
  final KYCRepository repo;

  UploadKYCUseCase(this.repo);

  Future<Map<String, dynamic>> call({
    required Map<String, String> kycData,
  }) {
    return repo.uploadKYC(kycData: kycData);
  }
}
