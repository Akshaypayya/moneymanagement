import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

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

  Future<BiometricResult> authenticate(String localizedReason) async {
    try {
      final isAvailable = await isBiometricsAvailable();
      if (!isAvailable) {
        return BiometricResult(
          success: false,
          errorCode: BiometricErrorCode.notAvailable,
          message: 'Biometric authentication is not available on this device',
        );
      }

      final biometricTypes = await getAvailableBiometrics();
      if (biometricTypes.isEmpty) {
        return BiometricResult(
          success: false,
          errorCode: BiometricErrorCode.notEnrolled,
          message: 'No biometrics enrolled on this device',
        );
      }

      final authenticated = await _auth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          useErrorDialogs: true,
        ),
      );

      if (authenticated) {
        return BiometricResult(
          success: true,
        );
      } else {
        return BiometricResult(
          success: false,
          errorCode: BiometricErrorCode.failed,
          message: 'Authentication failed',
        );
      }
    } catch (e) {
      BiometricErrorCode errorCode = BiometricErrorCode.unknown;
      String message = e.toString();

      if (e is PlatformException) {
        if (e.code == auth_error.notAvailable) {
          errorCode = BiometricErrorCode.notAvailable;
          message = 'Biometric authentication not available';
        } else if (e.code == auth_error.notEnrolled) {
          errorCode = BiometricErrorCode.notEnrolled;
          message = 'No biometrics enrolled on this device';
        } else if (e.code == auth_error.lockedOut ||
            e.code == auth_error.permanentlyLockedOut) {
          errorCode = BiometricErrorCode.lockedOut;
          message =
              'Too many failed attempts. Biometric authentication is locked';
        } else if (e.code == 'no_fragment_activity') {
          errorCode = BiometricErrorCode.notAvailable;
          message = 'App configuration issue: Requires FlutterFragmentActivity';
          debugPrint(
              'BIOMETRIC ERROR: This error occurs because MainActivity needs to extend FlutterFragmentActivity');
        }
      }

      debugPrint('Biometric authentication error: $message');

      return BiometricResult(
        success: false,
        errorCode: errorCode,
        message: message,
      );
    }
  }
}

class BiometricResult {
  final bool success;
  final BiometricErrorCode? errorCode;
  final String? message;

  BiometricResult({
    required this.success,
    this.errorCode,
    this.message,
  });
}

enum BiometricErrorCode {
  notAvailable,
  notEnrolled,
  lockedOut,
  failed,
  unknown,
}
