import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/internet_checker/service/internet_connection_service.dart';

enum InternetStatus {
  connected,
  disconnected,
  checking,
}

final internetStatusProvider =
    StateNotifierProvider<InternetStatusNotifier, InternetStatus>((ref) {
  return InternetStatusNotifier();
});

final internetCheckProvider = FutureProvider<bool>((ref) async {
  return await InternetService.hasInternetConnection();
});

final internetServiceProvider = Provider<InternetService>((ref) {
  return InternetService();
});

class InternetStatusNotifier extends StateNotifier<InternetStatus> {
  Timer? _timer;
  static const Duration _checkInterval = Duration(seconds: 30);

  InternetStatusNotifier() : super(InternetStatus.checking) {
    _startPeriodicCheck();
    _checkInitialConnection();
  }

  Future<void> _checkInitialConnection() async {
    await checkConnection();
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(_checkInterval, (timer) {
      checkConnection();
    });
  }

  Future<void> checkConnection() async {
    try {
      state = InternetStatus.checking;
      final hasConnection = await InternetService.hasInternetConnection();
      state = hasConnection
          ? InternetStatus.connected
          : InternetStatus.disconnected;
    } catch (e) {
      state = InternetStatus.disconnected;
    }
  }

  Future<void> forceCheck() async {
    await checkConnection();
  }

  void stopPeriodicCheck() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopPeriodicCheck();
    super.dispose();
  }
}
