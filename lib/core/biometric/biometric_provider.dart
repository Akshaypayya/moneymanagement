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
      : super(SharedPreferencesHelper.getBool('biometric_enabled') ?? false);

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

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/biometric/biometric_service.dart';
// import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
// import 'package:growk_v2/views.dart';
// import 'package:local_auth/local_auth.dart';

// final biometricServiceProvider = Provider<BiometricService>((ref) {
//   return BiometricService();
// });

// final biometricEnabledProvider =
//     StateNotifierProvider<BiometricEnabledNotifier, bool>((ref) {
//   return BiometricEnabledNotifier();
// });

// class BiometricEnabledNotifier extends StateNotifier<bool> {
//   BiometricEnabledNotifier()
//       : super(SharedPreferencesHelper.getBool('biometric_enabled') ?? false);

//   void toggleBiometric(bool enabled) {
//     SharedPreferencesHelper.saveBool('biometric_enabled', enabled);
//     state = enabled;

//     final phoneNumber = SharedPreferencesHelper.getString('phone_number');
//     if (phoneNumber != null) {
//       _saveUserSpecificBiometricPreference(phoneNumber, enabled);
//     }
//   }

//   void _saveUserSpecificBiometricPreference(String phoneNumber, bool enabled) {
//     final key = 'biometric_preference_$phoneNumber';
//     SharedPreferencesHelper.saveBool(key, enabled);
//     debugPrint('Saved biometric preference for user $phoneNumber: $enabled');
//   }

//   bool _getUserSpecificBiometricPreference(String phoneNumber) {
//     final key = 'biometric_preference_$phoneNumber';
//     return SharedPreferencesHelper.getBool(key) ?? false;
//   }

//   void restoreUserBiometricPreference(String phoneNumber) {
//     final userPreference = _getUserSpecificBiometricPreference(phoneNumber);
//     SharedPreferencesHelper.saveBool('biometric_enabled', userPreference);
//     state = userPreference;
//     debugPrint(
//         'Restored biometric preference for user $phoneNumber: $userPreference');
//   }

//   void temporarilyDisableBiometric() {
//     SharedPreferencesHelper.saveBool('biometric_enabled', false);
//     state = false;
//     debugPrint('Temporarily disabled biometric for security during logout');
//   }

//   void enableBiometricForNewUser(String phoneNumber) {
//     SharedPreferencesHelper.saveBool('biometric_enabled', true);
//     _saveUserSpecificBiometricPreference(phoneNumber, true);
//     state = true;
//     debugPrint('Enabled biometric for new user: $phoneNumber');
//   }

//   bool shouldShowBiometric(
//       {required bool isNewUser, required bool isBiometricSupported}) {
//     if (isNewUser) {
//       return isBiometricSupported;
//     } else {
//       return state && isBiometricSupported;
//     }
//   }

//   bool hadBiometricEnabledBefore(String phoneNumber) {
//     return _getUserSpecificBiometricPreference(phoneNumber);
//   }
// }

// final biometricTypesProvider = FutureProvider<List<String>>((ref) async {
//   final biometricService = ref.watch(biometricServiceProvider);

//   try {
//     final isAvailable = await biometricService.isBiometricsAvailable();
//     if (!isAvailable) {
//       return [];
//     }

//     final types = await biometricService.getAvailableBiometrics();
//     return types.map((type) {
//       switch (type) {
//         case BiometricType.face:
//           return 'Face ID';
//         case BiometricType.fingerprint:
//           return 'Fingerprint';
//         case BiometricType.iris:
//           return 'Iris';
//         case BiometricType.strong:
//           return 'Fingerprint';
//         case BiometricType.weak:
//           return 'Fingerprint';
//         default:
//           return 'Biometric';
//       }
//     }).toList();
//   } catch (e) {
//     return [];
//   }
// });

// final biometricSupportedProvider = FutureProvider<bool>((ref) async {
//   final biometricService = ref.watch(biometricServiceProvider);
//   return await biometricService.isBiometricsAvailable();
// });

// final biometricAuthenticatingProvider = StateProvider<bool>((ref) => false);

// final biometricResultProvider = StateProvider<BiometricResult?>((ref) => null);
