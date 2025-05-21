import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/storage/shared_preference/shared_preference_service.dart';

final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  return BiometricEnabledNotifier();
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  BiometricEnabledNotifier()
      : super(SharedPreferencesHelper.getBool('biometric_enabled') ?? false);

  void toggleBiometric(bool enabled) {
    SharedPreferencesHelper.saveBool('biometric_enabled', enabled);
    state = enabled;
  }
}
