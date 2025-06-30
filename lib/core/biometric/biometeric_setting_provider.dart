import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/views.dart';

final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  return BiometricEnabledNotifier();
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  BiometricEnabledNotifier()
      : super(SharedPreferencesHelper.getBool('biometric_enabled') ?? false);
// class BiometricEnabledNotifier extends StateNotifier<bool> {
//   BiometricEnabledNotifier() : super(false);

  void toggleBiometric(bool enabled) {
    SharedPreferencesHelper.saveBool('biometric_enabled', enabled);
    state = enabled;
  }
  // void toggleBiometric(bool enabled) async {
  //   await SharedPreferencesHelper.saveBool('biometric_enabled', enabled);
  //   debugPrint('toggleBiometric state: $enabled');
  //   state = enabled;
  //   debugPrint('Biometric state changed to: $enabled');
  // }

  // void reset() {
  //   state = false;
  //   SharedPreferencesHelper.remove('biometric_enabled');
  //   debugPrint('Biometric settings reset');
  // }
}
