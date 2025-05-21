import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:money_mangmnt/core/storage/shared_preference/shared_preference_service.dart';

final biometricServiceProvider = Provider<BiometricService>((ref) {
  return BiometricService();
});

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

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> isBiometricsAvailable() async {
    try {
      final canCheckBiometric = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return canCheckBiometric && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometrics availability: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access your account',
      );
    } catch (e) {
      debugPrint('Error authenticating: $e');
      return false;
    }
  }
}
