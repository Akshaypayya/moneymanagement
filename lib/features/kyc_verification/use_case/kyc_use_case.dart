import 'dart:io';

import 'package:growk_v2/features/kyc_verification/repo/kyc_repo.dart';

class UploadKYCUseCase {
  final KYCRepository repo;

  UploadKYCUseCase(this.repo);

  Future<Map<String, dynamic>> call({
    required Map<String, String> kycData,
  }) {
    return repo.uploadKYC(kycData: kycData);
  }
}
