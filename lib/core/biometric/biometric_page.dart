import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/biometric/biometric_provider.dart';
import 'package:growk_v2/core/biometric/biometric_service.dart';
import 'package:growk_v2/core/widgets/custom_scaffold.dart';
import 'package:growk_v2/core/widgets/reusable_padding.dart';
import 'package:growk_v2/routes/app_router.dart';

import '../../views.dart';

class BiometricAuthPage extends ConsumerStatefulWidget {
  const BiometricAuthPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BiometricAuthPage> createState() => _BiometricAuthPageState();
}

class _BiometricAuthPageState extends ConsumerState<BiometricAuthPage> {
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricSupport();
    });
  }

  Future<void> _checkBiometricSupport() async {
    final biometricService = ref.read(biometricServiceProvider);
    final isBiometricEnabled = ref.read(biometricEnabledProvider);

    if (!isBiometricEnabled) {
      _navigateToMainScreen();
      return;
    }

    try {
      final isSupported = await biometricService.isBiometricsAvailable();
      final biometricTypes = await biometricService.getAvailableBiometrics();

      if (isSupported && biometricTypes.isNotEmpty) {
        _authenticateWithBiometrics();
      } else {
        setState(() {
          _statusMessage = 'Biometrics not available on this device';
        });

        if (mounted) {
          _navigateToMainScreen();
        }
      }
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      _navigateToMainScreen();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    ref.read(biometricAuthenticatingProvider.notifier).state = true;

    final biometricService = ref.read(biometricServiceProvider);
    final result = await biometricService
        .authenticate('Authenticate to access your account');

    ref.read(biometricAuthenticatingProvider.notifier).state = false;
    ref.read(biometricResultProvider.notifier).state = result;

    if (result.success) {
      setState(() {
        _statusMessage = 'Authentication successful';
      });

      if (mounted) {
        _navigateToMainScreen();
      }
    } else {
      setState(() {
        _statusMessage = result.message ?? 'Authentication failed';
      });

      if (result.errorCode != BiometricErrorCode.notAvailable &&
          result.errorCode != BiometricErrorCode.notEnrolled) {
        Future.delayed(const Duration(seconds: 2), () {
          _exitApp();
        });
      } else {
        if (mounted) {
          _navigateToMainScreen();
        }
      }
    }
  }

  Future<void> _navigateToMainScreen() async {
    if (mounted) {
      await ref.read(userProfileControllerProvider).getUserProfile(ref);

      final profile = ref.read(userProfileStateProvider).userData;

      if (profile?.profileCompletion == 1) {
        ref.read(bottomNavBarProvider.notifier).state = 0;
        Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
      } else {
        ref.read(bottomNavBarProvider.notifier).state = 0;
        Navigator.pushReplacementNamed(
            context, AppRouter.editUserDetailsScreen);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isDark = ref.watch(isDarkProvider);
    final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
    final isAuthenticating = ref.watch(biometricAuthenticatingProvider);

    return WillPopScope(
      onWillPop: () async {
        _exitApp();
        return false;
      },
      child: ScalingFactor(
        child: CustomScaffold(
          backgroundColor: AppColors.current(isDark).background,
          body: Center(
            child:
                //  !isAuthenticating ? CircularProgressIndicator() :
                ReusablePadding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Image(image: AssetImage(logoPath)),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
// import 'package:growk_v2/core/constants/app_images.dart';
// import 'package:growk_v2/core/theme/app_theme.dart';
// import 'package:growk_v2/core/biometric/biometric_provider.dart';
// import 'package:growk_v2/core/biometric/biometric_service.dart';
// import 'package:growk_v2/core/widgets/custom_scaffold.dart';
// import 'package:growk_v2/core/widgets/reusable_padding.dart';
// import 'package:growk_v2/features/login/provider/user_data_provider.dart';
// import 'package:growk_v2/features/main/provider/main_provider.dart';
// import 'package:growk_v2/features/profile_page/provider/user_details_provider.dart';
// import 'package:growk_v2/routes/app_router.dart';

// class BiometricAuthPage extends ConsumerStatefulWidget {
//   const BiometricAuthPage({Key? key}) : super(key: key);

//   @override
//   ConsumerState<BiometricAuthPage> createState() => _BiometricAuthPageState();
// }

// class _BiometricAuthPageState extends ConsumerState<BiometricAuthPage> {
//   String _statusMessage = '';

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkBiometricSupport();
//     });
//   }

//   Future<void> _checkBiometricSupport() async {
//     final biometricService = ref.read(biometricServiceProvider);
//     final biometricNotifier = ref.read(biometricEnabledProvider.notifier);
//     final userData = ref.read(userDataProvider);

//     final isNewUser = userData.isNewUser ?? false;

//     try {
//       final isBiometricSupported =
//           await biometricService.isBiometricsAvailable();
//       final biometricTypes = await biometricService.getAvailableBiometrics();

//       debugPrint(
//           'Biometric supported: $isBiometricSupported, isNewUser: $isNewUser');

//       final shouldShowBiometric = biometricNotifier.shouldShowBiometric(
//         isNewUser: isNewUser,
//         isBiometricSupported: isBiometricSupported && biometricTypes.isNotEmpty,
//       );

//       debugPrint('Should show biometric: $shouldShowBiometric');

//       if (shouldShowBiometric) {
//         if (isNewUser) {
//           await _showBiometricSetup();
//         } else {
//           await _authenticateWithBiometrics();
//         }
//       } else {
//         setState(() {
//           _statusMessage = 'Proceeding to main screen...';
//         });
//         _navigateToMainScreen();
//       }
//     } catch (e) {
//       debugPrint('Error checking biometric support: $e');
//       setState(() {
//         _statusMessage = 'Error checking biometric support';
//       });
//       _navigateToMainScreen();
//     }
//   }

//   Future<void> _showBiometricSetup() async {
//     setState(() {
//       _statusMessage = 'Setting up biometric authentication...';
//     });

//     final biometricService = ref.read(biometricServiceProvider);

//     // final shouldEnable = await _showBiometricSetupDialog();

//     if (true) {
//       final result = await biometricService.authenticate(
//         'Set up biometric authentication',
//         // 'Set up biometric authentication for secure access',
//       );

//       if (result.success) {
//         ref.read(biometricEnabledProvider.notifier).enableBiometricForNewUser(
//               ref.read(userDataProvider).phoneNumber ?? '',
//             );
//         setState(() {
//           _statusMessage = 'Biometric authentication enabled!';
//         });

//         await Future.delayed(const Duration(seconds: 1));
//       } else {
//         setState(() {
//           _statusMessage = 'Biometric setup failed';
//         });
//       }
//     }

//     _navigateToMainScreen();
//   }

//   Future<void> _authenticateWithBiometrics() async {
//     ref.read(biometricAuthenticatingProvider.notifier).state = true;

//     setState(() {
//       _statusMessage = 'Authenticating...';
//     });

//     final biometricService = ref.read(biometricServiceProvider);
//     final result = await biometricService
//         .authenticate('Authenticate to access your account');

//     ref.read(biometricAuthenticatingProvider.notifier).state = false;
//     ref.read(biometricResultProvider.notifier).state = result;

//     if (result.success) {
//       setState(() {
//         _statusMessage = 'Authentication successful!';
//       });

//       await Future.delayed(const Duration(milliseconds: 500));
//       _navigateToMainScreen();
//     } else {
//       setState(() {
//         _statusMessage = result.message ?? 'Authentication failed';
//       });

//       if (result.errorCode == BiometricErrorCode.notAvailable ||
//           result.errorCode == BiometricErrorCode.notEnrolled) {
//         await Future.delayed(const Duration(seconds: 2));
//         _navigateToMainScreen();
//       } else if (result.errorCode == BiometricErrorCode.userCancel) {
//         _showRetryDialog();
//       } else {
//         await Future.delayed(const Duration(seconds: 2));
//         _exitApp();
//       }
//     }
//   }

//   // Future<bool> _showBiometricSetupDialog() async {
//   //   return await showDialog<bool>(
//   //         context: context,
//   //         barrierDismissible: false,
//   //         builder: (BuildContext context) {
//   //           final isDark = Theme.of(context).brightness == Brightness.dark;

//   //           return AlertDialog(
//   //             backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//   //             title: Text(
//   //               'Enable Biometric Authentication',
//   //               style: TextStyle(
//   //                 color: isDark ? Colors.white : Colors.black,
//   //               ),
//   //             ),
//   //             content: Text(
//   //               'Would you like to enable biometric authentication for faster and more secure access?',
//   //               style: TextStyle(
//   //                 color: isDark ? Colors.white70 : Colors.black87,
//   //               ),
//   //             ),
//   //             actions: [
//   //               TextButton(
//   //                 onPressed: () => Navigator.of(context).pop(false),
//   //                 child: Text(
//   //                   'Skip',
//   //                   style: TextStyle(
//   //                     color: isDark ? Colors.white70 : Colors.black54,
//   //                   ),
//   //                 ),
//   //               ),
//   //               ElevatedButton(
//   //                 style: ElevatedButton.styleFrom(
//   //                   backgroundColor: isDark ? Colors.blue : Colors.blue,
//   //                 ),
//   //                 onPressed: () => Navigator.of(context).pop(true),
//   //                 child: const Text(
//   //                   'Enable',
//   //                   style: TextStyle(color: Colors.white),
//   //                 ),
//   //               ),
//   //             ],
//   //           );
//   //         },
//   //       ) ??
//   //       false;
//   // }

//   Future<void> _showRetryDialog() async {
//     final shouldRetry = await showDialog<bool>(
//           context: context,
//           barrierDismissible: false,
//           builder: (BuildContext context) {
//             final isDark = Theme.of(context).brightness == Brightness.dark;

//             return AlertDialog(
//               backgroundColor: isDark ? Colors.grey[900] : Colors.white,
//               title: Text(
//                 'Authentication Required',
//                 style: TextStyle(
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//               content: Text(
//                 'Biometric authentication is required to access the app. Would you like to try again?',
//                 style: TextStyle(
//                   color: isDark ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(false),
//                   child: Text(
//                     'Exit',
//                     style: TextStyle(
//                       color: isDark ? Colors.red : Colors.red,
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                   onPressed: () => Navigator.of(context).pop(true),
//                   child: const Text('Retry'),
//                 ),
//               ],
//             );
//           },
//         ) ??
//         false;

//     if (shouldRetry) {
//       await _authenticateWithBiometrics();
//     } else {
//       _exitApp();
//     }
//   }

//   Future<void> _navigateToMainScreen() async {
//     if (mounted) {
//       try {
//         await ref.read(userProfileControllerProvider).getUserProfile(ref);
//         final profile = ref.read(userProfileStateProvider).userData;

//         if (profile?.profileCompletion == 1) {
//           ref.read(bottomNavBarProvider.notifier).state = 0;
//           Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
//         } else {
//           ref.read(bottomNavBarProvider.notifier).state = 0;
//           Navigator.pushReplacementNamed(
//               context, AppRouter.editUserDetailsScreen);
//         }
//       } catch (e) {
//         debugPrint('Error navigating to main screen: $e');
//         Navigator.pushReplacementNamed(context, AppRouter.login);
//       }
//     }
//   }

//   void _exitApp() {
//     if (Platform.isAndroid) {
//       SystemNavigator.pop();
//     } else if (Platform.isIOS) {
//       exit(0);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final isDark = ref.watch(isDarkProvider);
//     final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;
//     final isAuthenticating = ref.watch(biometricAuthenticatingProvider);

//     return WillPopScope(
//       onWillPop: () async {
//         _exitApp();
//         return false;
//       },
//       child: ScalingFactor(
//         child: CustomScaffold(
//           backgroundColor: AppColors.current(isDark).background,
//           body: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ReusablePadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 120),
//                   child: Image(image: AssetImage(logoPath)),
//                 ),
//                 const SizedBox(height: 40),
//                 if (isAuthenticating)
//                   CircularProgressIndicator(
//                       color: isDark ? Colors.white : Colors.black),

//                 // else if (_statusMessage.isNotEmpty)
//                 //   Padding(
//                 //     padding: const EdgeInsets.symmetric(horizontal: 40),
//                 //     child: Text(
//                 //       _statusMessage,
//                 //       textAlign: TextAlign.center,
//                 //       style: TextStyle(
//                 //         color: isDark ? Colors.white70 : Colors.black87,
//                 //         fontSize: 16,
//                 //       ),
//                 //     ),
//                 //   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
