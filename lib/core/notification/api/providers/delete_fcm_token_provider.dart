import 'package:growk_v2/core/notification/api/controller/delete_fcm_token_controller.dart';
import 'package:growk_v2/core/notification/api/repo/delete_fcm_token_repo.dart';
import 'package:growk_v2/core/notification/api/use_case/delete_fcm_token_use_case.dart';

import '../../../../views.dart';

final deleteFcmTokenRepoProvider = Provider<DeleteFcmTokenRepo>((ref) {
  final network = ref.read(networkServiceProvider);
  return DeleteFcmTokenRepo(network);
});
final deleteFcmTokenUseCaseProvider = Provider<DeleteFcmTokenUseCase>((ref) {
  final repo = ref.read(deleteFcmTokenRepoProvider);
  return DeleteFcmTokenUseCase(repo);
});
final deleteFcmTokenControllerProvider =
AsyncNotifierProvider<DeleteFcmTokenController, void>(
      () => DeleteFcmTokenController(),
);
