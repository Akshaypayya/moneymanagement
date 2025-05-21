import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/routes/app_router.dart';
import 'package:local_auth/local_auth.dart';

class BiometricPage extends ConsumerStatefulWidget {
  const BiometricPage({Key? key}) : super(key: key);

  @override
  ConsumerState<BiometricPage> createState() => _BiometricPageState();
}

enum SupportState {
  unknown,
  supported,
  unSupported,
}

class _BiometricPageState extends ConsumerState<BiometricPage> {
  final LocalAuthentication auth = LocalAuthentication();
  SupportState supportState = SupportState.unknown;
  List<BiometricType>? availableBiometrics;
  bool isAuthenticating = false;
  bool showVerifiedAnimation = false;

  @override
  void initState() {
    super.initState();
    checkBiometricSupport();
  }

  Future<void> checkBiometricSupport() async {
    try {
      final canCheckBiometric = await auth.canCheckBiometrics;
      final isDeviceSupported = await auth.isDeviceSupported();

      final biometricTypes = await auth.getAvailableBiometrics();

      setState(() {
        availableBiometrics = biometricTypes;
        supportState = (canCheckBiometric &&
                isDeviceSupported &&
                biometricTypes.isNotEmpty)
            ? SupportState.supported
            : SupportState.unSupported;
      });

      if (supportState == SupportState.supported) {
        authenticateWithBiometrics();
      } else {
        Future.delayed(Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
          }
        });
      }
    } catch (e) {
      debugPrint('Error checking biometric support: $e');
      setState(() {
        supportState = SupportState.unSupported;
      });

      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
        }
      });
    }
  }

  Future<void> authenticateWithBiometrics() async {
    setState(() {
      isAuthenticating = true;
    });

    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Authenticate with fingerprint or Face ID to continue',
      );

      if (authenticated) {
        setState(() {
          showVerifiedAnimation = true;
          isAuthenticating = false;
        });

        Future.delayed(
          Duration(milliseconds: 500),
          () {
            if (mounted) {
              Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
            }
          },
        );
      } else {
        closeApp();
      }
    } catch (e) {
      debugPrint('Authentication error: $e');
      closeApp();
    }
  }

  void closeApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final isDark = ref.watch(isDarkProvider);
    final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;

    return WillPopScope(
      onWillPop: () async {
        closeApp();
        return false;
      },
      child: ScalingFactor(
        child: Scaffold(
          backgroundColor: AppColors.current(isDark).background,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  height: height * 0.1,
                  width: width * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: AssetImage(logoPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.01),
              Center(
                child: Text(
                  'GrowK',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              ),
              SizedBox(height: height * 0.03),
              if (supportState == SupportState.supported &&
                  !showVerifiedAnimation)
                Text(
                  'Please authenticate to continue',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 16,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                  ),
                ),
              if (showVerifiedAnimation)
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 40,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
