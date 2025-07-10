import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_protector/screen_protector.dart';

final screenProtectorProvider =
NotifierProvider<ScreenProtectorController, bool>(
  ScreenProtectorController.new,
);

class ScreenProtectorController extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> enableProtection() async {
    await ScreenProtector.preventScreenshotOn();
    state = true;
  }

  Future<void> disableProtection() async {
    await ScreenProtector.preventScreenshotOff();
    state = false;
  }

  Future<void> toggleProtection() async {
    if (state) {
      await disableProtection();
    } else {
      await enableProtection();
    }
  }
}
