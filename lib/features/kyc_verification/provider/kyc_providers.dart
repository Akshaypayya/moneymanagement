import 'dart:io';

import 'package:growk_v2/features/kyc_verification/controller/kyc_controller.dart';
import 'package:growk_v2/features/kyc_verification/repo/kyc_repo.dart';
import '../../../views.dart';

final kycRepoProvider = Provider<KYCRepository>((ref) {
  final network = ref.watch(networkServiceProvider);
  return KYCRepository(network);
});

final kycControllerProvider = AsyncNotifierProvider<KYCController, void>(
  KYCController.new,
);

final kycIdControllerProvider = Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(() => controller.dispose());
  return controller;
});

final kycIdErrorProvider = StateProvider<String?>((ref) => null);
