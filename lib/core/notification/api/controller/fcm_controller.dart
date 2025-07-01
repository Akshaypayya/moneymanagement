import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:growk_v2/core/notification/api/providers/add_fcm_token_providers.dart';
import 'package:growk_v2/core/notification/api/use_case/add_fcm_token_use_case.dart';
class FcmTokenController extends AsyncNotifier<void> {
  late final AddFcmTokenUseCase _useCase;

  @override
  FutureOr<void> build() {
    _useCase = ref.read(addFcmTokenUseCaseProvider);
  }

  Future<void> sendFcmToken(BuildContext context, String token,WidgetRef ref) async {
    state = const AsyncLoading();
    try {
      final response = await _useCase(token);
      debugPrint("FCM Token sent successfully: ${response.status}");
      state = const AsyncData(null);
    } catch (e, st) {
      debugPrint("Failed to send FCM Token: $e");
      debugPrintStack(stackTrace: st);
      state = AsyncError(e, st);
    }
  }
}
