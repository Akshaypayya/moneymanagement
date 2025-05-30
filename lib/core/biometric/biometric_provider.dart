import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/biometric/biometric_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:local_auth/local_auth.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

final biometricEnabledProvider =
    StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
  return BiometricEnabledNotifier();
});

class BiometricEnabledNotifier extends StateNotifier<bool> {
  BiometricEnabledNotifier()
      : super(SharedPreferencesHelper.getBool('biometric_enabled') ?? true);

  void toggleBiometric(bool enabled) {
    SharedPreferencesHelper.saveBool('biometric_enabled', enabled);
    state = enabled;
  }
}

final biometricTypesProvider = FutureProvider<List<String>>((ref) async {
  final biometricService = ref.watch(biometricServiceProvider);

  try {
    final isAvailable = await biometricService.isBiometricsAvailable();
    if (!isAvailable) {
      return [];
    }

    final types = await biometricService.getAvailableBiometrics();
    return types.map((type) {
      switch (type) {
        case BiometricType.face:
          return 'Face ID';
        case BiometricType.fingerprint:
          return 'Fingerprint';
        case BiometricType.iris:
          return 'Iris';
        case BiometricType.strong:
          // return 'Strong biometric';
          return 'Fingerprint';
        case BiometricType.weak:
          // return 'Weak biometric';
          return 'Fingerprint';
        default:
          return 'Biometric';
      }
    }).toList();
  } catch (e) {
    return [];
  }
});

final biometricSupportedProvider = FutureProvider<bool>((ref) async {
  final biometricService = ref.watch(biometricServiceProvider);
  return await biometricService.isBiometricsAvailable();
});

final biometricAuthenticatingProvider = StateProvider<bool>((ref) => false);

final biometricResultProvider = StateProvider<BiometricResult?>((ref) => null);
