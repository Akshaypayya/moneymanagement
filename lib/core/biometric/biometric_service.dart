// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';

// class BiometricService {
//   final LocalAuthentication _auth = LocalAuthentication();

//   Future<bool> isBiometricsAvailable() async {
//     try {
//       final canCheckBiometric = await _auth.canCheckBiometrics;
//       final isDeviceSupported = await _auth.isDeviceSupported();
//       return canCheckBiometric && isDeviceSupported;
//     } catch (e) {
//       debugPrint('Error checking biometrics availability: $e');
//       return false;
//     }
//   }

//   Future<List<BiometricType>> getAvailableBiometrics() async {
//     try {
//       return await _auth.getAvailableBiometrics();
//     } catch (e) {
//       debugPrint('Error getting available biometrics: $e');
//       return [];
//     }
//   }

//   Future<bool> authenticate() async {
//     try {
//       return await _auth.authenticate(
//         localizedReason: 'Authenticate to access your account',
//       );
//     } catch (e) {
//       debugPrint('Error authenticating: $e');
//       return false;
//     }
//   }
// }
