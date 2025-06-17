import 'package:growk_v2/core/biometric/biometric_provider.dart';
import 'package:growk_v2/views.dart';

class OtpController {
  final Ref ref;

  OtpController(this.ref);

  Future<void> validateOtp(BuildContext context) async {
    final cellNo = ref.read(phoneInputProvider);
    final enteredOtp = ref.read(otpInputProvider);

    debugPrint('cellNo: $cellNo');
    debugPrint('enteredOtp: $enteredOtp');

    if (enteredOtp.length != 4) {
      ref.read(otpErrorProvider.notifier).state = "Please enter full OTP";
      return;
    }

    ref.read(isButtonLoadingProvider.notifier).state = true;

    try {
      final response = await ref.read(otpUseCaseProvider).call(cellNo, enteredOtp);

      if (response.isSuccess) {
        final data = response.data ?? {};
        final isNewUser = data['isNewUser'] ?? false;
        debugPrint('isNewUser: $isNewUser');

        ref.read(userDataProvider.notifier).setUserData(data, phoneNumber: cellNo);
        ref.read(otpErrorProvider.notifier).state = null;
        ref.read(isButtonLoadingProvider.notifier).state = false;


        if (isNewUser) {
          final isSupported = await ref.read(biometricSupportedProvider.future);
          final isAlreadyEnabled = ref.read(biometricEnabledProvider);
          debugPrint('Biometric already enabled: $isAlreadyEnabled');
          if (isSupported && !isAlreadyEnabled) {
            final biometricService = ref.read(biometricServiceProvider);
            final result = await biometricService.authenticate(
              'Authenticate to enable biometric login',
            );
            if (result.success) {
              ref.read(biometricEnabledProvider.notifier).toggleBiometric(true);
              debugPrint('Biometric already enabled: $isAlreadyEnabled');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Biometric authentication enabled')),
              );
              ref.read(isButtonLoadingProvider.notifier).state = false;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to enable biometrics: ${result.message}')),
              );
            }
          }
        }
        await Navigator.pushNamedAndRemoveUntil(
          context,
          isNewUser ? AppRouter.applyReferralCode : AppRouter.mainScreen,
              (route) => false,
        );
        ref.read(isButtonLoadingProvider.notifier).state = true;
      } else {
        ref.read(otpErrorProvider.notifier).state =
            response.message ?? 'OTP verification failed';
        ref.read(otpInputProvider.notifier).state = '';
      }
    } catch (e, stackTrace) {
      debugPrint('OTP Error: $e');
      debugPrint('Stack Trace:\n$stackTrace');
      ref.read(otpErrorProvider.notifier).state = 'Something went wrong';
    } finally {
      ref.read(isButtonLoadingProvider.notifier).state = false;
    }
  }

  Future<void> resendLoginOtp(BuildContext context) async {
    final cellNo = ref.read(phoneInputProvider);
    final remainingTime = ref.read(otpTimerProvider);

    if (remainingTime > 0) return;

    ref.read(otpErrorProvider.notifier).state = null;

    try {
      final response = await ref.read(loginUseCaseProvider).call(cellNo);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP resent successfully")),
        );
        ref.read(otpTimerProvider.notifier).reset(); // Restart timer
      } else {
        ref.read(otpErrorProvider.notifier).state =
            response.message ?? "Failed to resend OTP";
      }
    } catch (e) {
      debugPrint("Resend OTP Error: $e");
      ref.read(otpErrorProvider.notifier).state =
      "Something went wrong while resending OTP";
    } finally {
    }
  }
}
