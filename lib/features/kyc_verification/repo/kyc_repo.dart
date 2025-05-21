import 'dart:io';
import '../../../views.dart';

class KYCRepository {
  final NetworkService network;

  KYCRepository(this.network);

  Future<Map<String, dynamic>> uploadKYC({
    required Map<String, String> kycData,
  }) async {
    return await network.post(
      '/user-service/user/kycVerification',
      body: kycData,
        headers: {
          'Content-Type': 'application/json',
          'app': 'SA',
        }

    );
  }
}
