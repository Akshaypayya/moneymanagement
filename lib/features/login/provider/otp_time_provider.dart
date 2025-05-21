import 'dart:async';
import '../../../views.dart';

final otpTimerProvider = StateNotifierProvider<OtpTimerNotifier, int>((ref) {
  return OtpTimerNotifier();
});

class OtpTimerNotifier extends StateNotifier<int> {
  OtpTimerNotifier() : super(59) {
    _startCountdown();
  }

  Timer? _timer;

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state == 0) {
        timer.cancel();
      } else {
        state = state - 1;
      }
    });
  }

  void reset() {
    state = 59;
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final otpErrorProvider = StateProvider<String?>((ref) => null);

final otpInputProvider = StateProvider<String>((ref) => '');
