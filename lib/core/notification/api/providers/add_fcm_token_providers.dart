import 'package:growk_v2/core/notification/api/controller/fcm_controller.dart';
import 'package:growk_v2/core/notification/api/repo/add_fcm_token_repo.dart';
import 'package:growk_v2/core/notification/api/use_case/add_fcm_token_use_case.dart';

import '../../../../views.dart';

final addFcmTokenRepoProvider = Provider<AddFcmTokenRepo>((ref) {
  final networkService = ref.read(networkServiceProvider);
  return AddFcmTokenRepo(networkService);
});

final addFcmTokenUseCaseProvider = Provider<AddFcmTokenUseCase>((ref) {
  final repo = ref.read(addFcmTokenRepoProvider);
  return AddFcmTokenUseCase(repo);
});
final fcmTokenControllerProvider =
AsyncNotifierProvider<FcmTokenController, void>(() => FcmTokenController());
