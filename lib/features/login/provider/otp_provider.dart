import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/login/controller/otp_controller.dart';
import 'package:growk_v2/features/login/provider/login_provider.dart';
import 'package:growk_v2/features/login/repo/otp_repo.dart';
import 'package:growk_v2/features/login/use_case/otp_use_case.dart';
import '../../../core/constants/app_url.dart';
import '../../../core/network/network_service.dart';

final otpNetworkProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: ref.watch(httpClientProvider),
    baseUrl: AppUrl.baseUrl,
  );
});

final otpRepoProvider = Provider((ref) {
  return OtpRepository(ref.watch(otpNetworkProvider));
});

final otpUseCaseProvider = Provider((ref) {
  return OtpUseCase(ref.watch(otpRepoProvider));
});
final otpControllerProvider = Provider<OtpController>((ref) {
  return OtpController(ref);
});
