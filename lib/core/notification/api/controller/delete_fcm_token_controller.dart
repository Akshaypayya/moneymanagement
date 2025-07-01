import 'dart:async';
import 'package:growk_v2/core/notification/api/providers/delete_fcm_token_provider.dart';
import 'package:growk_v2/core/notification/api/use_case/delete_fcm_token_use_case.dart';
import '../../../../views.dart';

class DeleteFcmTokenController extends AsyncNotifier<void> {
  late final DeleteFcmTokenUseCase _useCase;

  @override
  FutureOr<void> build() {
    _useCase = ref.read(deleteFcmTokenUseCaseProvider);
  }

  Future<void> deleteFcmToken(BuildContext context,WidgetRef ref) async {
    state = const AsyncLoading();
    try {
      final response = await _useCase();
      debugPrint("FCM Token deleted: ${response.message}");
      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint("Failed to delete FCM Token: $e");
      state = AsyncError(e, st);

      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: "Failed to delete device token.",
        type: SnackType.error,
      );
    }
  }
}
