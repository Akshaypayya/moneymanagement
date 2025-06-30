import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/biometric/biometeric_setting_provider.dart';
import 'package:growk_v2/core/services/data_clearing_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/login/provider/user_data_provider.dart';
import 'package:growk_v2/features/logout/provider/logout_provider.dart';
import 'package:growk_v2/main.dart';
import 'package:growk_v2/routes/app_router.dart';

class LogoutController {
  final Ref ref;

  LogoutController(this.ref);

  Future<void> logout(BuildContext context, WidgetRef ref) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final isDark = ref.watch(isDarkProvider);

    _showLoadingDialog(context);
    ref.read(isLogoutLoadingProvider.notifier).state = true;

    try {
      final refreshToken = ref.read(userDataProvider).refreshToken;
      final token = ref.read(userDataProvider).accessToken;

      debugPrint('Access Token for auth: $token');
      debugPrint('Refresh Token for body: $refreshToken');

      if (refreshToken == null || token == null) {
        debugPrint('Tokens not available for logout');
        _clearUserData(ref);

        if (navigator.canPop()) {
          navigator.pop();
        }

        navigator.pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

        _showLoginMessage(scaffoldMessenger, isDark);
        return;
      }

      final response =
          await ref.read(logoutRepoProvider).logoutUser(refreshToken, token);

      _clearUserData(ref);

      if (response.isSuccess) {
        debugPrint('Logout Success: ${response.message}');
      } else {
        debugPrint('Logout Failed: ${response.message}');
      }

      if (navigator.canPop()) {
        navigator.pop();
      }

      navigator.pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

      _showLoginMessage(scaffoldMessenger, isDark);
    } catch (e) {
      debugPrint('Logout Exception: $e');
      _clearUserData(ref);

      if (navigator.canPop()) {
        navigator.pop();
      }

      navigator.pushNamedAndRemoveUntil(AppRouter.login, (route) => false);

      _showLoginMessage(scaffoldMessenger, isDark);
    } finally {
      ref.read(isLogoutLoadingProvider.notifier).state = false;
    }
  }

  void _showLoginMessage(
      ScaffoldMessengerState scaffoldMessenger, bool isDark) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          'Please login to continue',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: isDark ? Colors.grey[800] : Colors.black87,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearUserData(WidgetRef ref) {
    try {
      // ref.read(userDataProvider.notifier).clear();
      // // logoutAndResetApp(context);
      // ref.read(biometricEnabledProvider.notifier).toggleBiometric(false);
      // ref.read(providerResetServiceProvider).clearAll(ref);
      SharedPreferencesHelper.clear();

      ref.read(userDataProvider.notifier).clear();
      ref.read(biometricEnabledProvider.notifier).toggleBiometric(false);
      // ref.read(biometricEnabledProvider.notifier).reset();
      ref.read(providerResetServiceProvider).clearAll(ref);
      debugPrint('User data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing user data: $e');
      SharedPreferencesHelper.clear();
    }
  }
  // void logoutAndResetApp(BuildContext context) async {
  //   // Step 1: Clear shared preferences
  //   await SharedPreferencesHelper.clear();
  //
  //   // Step 2: Restart app with new ProviderScope key
  //   runApp(
  //     ProviderScope(
  //       key: GlobalKey(), // New key = new provider tree
  //       child: const MyApp(),
  //     ),
  //   );
  // }

  void _showLoadingDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Logging out...',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/biometric/biometric_provider.dart';
// import 'package:growk_v2/core/services/data_clearing_service.dart';
// import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
// import 'package:growk_v2/features/login/provider/user_data_provider.dart';

// class LogoutController {
//   Future<void> logout(BuildContext context, WidgetRef ref) async {
//     try {
//       _showLoadingDialog(context);

//       // Clear user data
//       _clearUserData(ref);

//       // IMPORTANT: Only temporarily disable biometric (preserve user preferences)
//       _temporarilyDisableBiometric(ref);

//       // Navigate to login screen
//       Navigator.of(context).pop(); // Close loading dialog

//       // Navigate to login and clear all routes
//       Navigator.of(context).pushNamedAndRemoveUntil(
//         '/login', // or your login route
//         (route) => false,
//       );

//       _showSuccessMessage(context);
//     } catch (e) {
//       Navigator.of(context).pop(); // Close loading dialog
//       _showErrorMessage(context, e.toString());
//     }
//   }

//   static void _clearUserData(WidgetRef ref) {
//     try {
//       ref.read(userDataProvider.notifier).clear();
//       ref.read(providerResetServiceProvider).clearAll(ref);
//       debugPrint('User data cleared successfully');
//     } catch (e) {
//       debugPrint('Error clearing user data: $e');
//       SharedPreferencesHelper.clear();
//     }
//   }

//   // FIXED: Only temporarily disable biometric, preserve user preferences
//   static void _temporarilyDisableBiometric(WidgetRef ref) {
//     try {
//       // Temporarily disable biometric for security, but preserve user-specific preferences
//       ref.read(biometricEnabledProvider.notifier).temporarilyDisableBiometric();

//       // Clear biometric result state
//       ref.read(biometricResultProvider.notifier).state = null;
//       ref.read(biometricAuthenticatingProvider.notifier).state = false;

//       debugPrint(
//           'Biometric temporarily disabled for security - user preferences preserved');
//     } catch (e) {
//       debugPrint('Error temporarily disabling biometric: $e');
//       // Fallback: manually disable current session only
//       SharedPreferencesHelper.saveBool('biometric_enabled', false);
//     }
//   }

//   static void _showSuccessMessage(BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text('Logged out successfully'),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   static void _showErrorMessage(BuildContext context, String error) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Logout failed: $error'),
//         backgroundColor: Colors.red,
//         duration: const Duration(seconds: 3),
//       ),
//     );
//   }

//   static void _showLoadingDialog(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(
//                 valueColor: AlwaysStoppedAnimation<Color>(
//                   isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'Logging out...',
//                 style: TextStyle(
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
