import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/biometric/biometric_provider.dart';
import 'package:money_mangmnt/core/biometric/biometric_service.dart';
import 'package:money_mangmnt/core/widgets/custom_scaffold.dart';
import 'package:money_mangmnt/core/widgets/reusable_padding.dart';
import 'package:money_mangmnt/routes/app_router.dart';

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

  void _navigateToMainScreen() {
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
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
