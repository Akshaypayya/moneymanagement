import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/check_rooted_device/blocked_app.dart';
import 'package:growk_v2/core/check_rooted_device/check_rooted_device.dart';
import 'package:growk_v2/core/check_rooted_device/root_guard.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/biometric/biometric_provider.dart';
import 'package:growk_v2/core/widgets/custom_scaffold.dart';
import 'package:growk_v2/core/widgets/reusable_padding.dart';
import 'package:growk_v2/features/splash/provider/splash_provider.dart';
import 'package:growk_v2/routes/app_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 2000));

    // // Read the secure state from provider
    // final isSecureAsync = ref.read(isDeviceSecureProvider);

    // // Wait for the async value to resolve
    // final isSecure = await ref.read(isDeviceSecureProvider.future);

    // if (!isSecure) {
    //   if (!mounted) return;
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const BlockedApp()),
    //   );
    //   return;
    // }

    if (!mounted) return;

    final accessToken = SharedPreferencesHelper.getString('access_token');
    final isLoggedIn = accessToken != null && accessToken.isNotEmpty;

    if (!isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRouter.login);
      return;
    }

    final isBiometricEnabled = ref.read(biometricEnabledProvider);

    if (isBiometricEnabled) {
      final biometricService = ref.read(biometricServiceProvider);
      final biometricsAvailable =
          await biometricService.isBiometricsAvailable();

      if (biometricsAvailable) {
        Navigator.pushReplacementNamed(context, AppRouter.biometricAuth);
      } else {
        Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;

    return ScalingFactor(
      child: CustomScaffold(
        backgroundColor: AppColors.current(isDark).background,
        body: Center(
          child: ReusablePadding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Image(image: AssetImage(logoPath)),
          ),
        ),
      ),
    );
  }
}
