import 'package:growk_v2/core/biometric/biometric_provider.dart';
import 'package:growk_v2/views.dart';

class OtpController {
  final Ref ref;

  OtpController(this.ref);

  Future<void> validateOtp(BuildContext context, WidgetRef ref) async {
    final cellNo = ref.read(phoneInputProvider);
    final enteredOtp = ref.read(otpInputProvider);
    final texts = ref.read(appTextsProvider);

    debugPrint('cellNo: $cellNo');
    debugPrint('enteredOtp: $enteredOtp');

    if (enteredOtp.length != 4) {
      ref.read(otpErrorProvider.notifier).state = texts.pleaseEnterFullOtp;
      return;
    }

    ref.read(isButtonLoadingProvider.notifier).state = true;

    try {
      final response =
          await ref.read(otpUseCaseProvider).call(cellNo, enteredOtp);

      if (response.isSuccess) {
        ref.read(isButtonLoadingProvider.notifier).state = false;

        final data = response.data ?? {};
        final isNewUser = data['isNewUser'] ?? false;
        debugPrint('isNewUser: $isNewUser');

        ref
            .read(userDataProvider.notifier)
            .setUserData(data, phoneNumber: cellNo);
        ref.read(otpErrorProvider.notifier).state = null;

        final isSupported = await ref.read(biometricSupportedProvider.future);
        final isAlreadyEnabled = ref.read(biometricEnabledProvider);

        if (isSupported) {
          final biometricService = ref.read(biometricServiceProvider);
          final result = await biometricService.authenticate(
            texts.authenticateBiometric,
          );

          if (result.success) {
            ref.read(biometricEnabledProvider.notifier).toggleBiometric(true);
            if (context.mounted) {
              showGrowkSnackBar(
                context: context,
                ref: ref,
                message: texts.biometricEnabled,
                type: SnackType.success,
              );
            }
          } else {
            ref.read(biometricEnabledProvider.notifier).toggleBiometric(false);
            if (context.mounted) {
              showGrowkSnackBar(
                context: context,
                ref: ref,
                message: '${texts.biometricFailed} ${result.message ?? ''}',
                type: SnackType.error,
              );
            }
          }
        }

        ref.read(isButtonLoadingProvider.notifier).state = false;

        await Navigator.pushNamedAndRemoveUntil(
          context,
          isNewUser ? AppRouter.applyReferralCode : AppRouter.mainScreen,
          (route) => false,
        );
      } else {
        ref.read(isButtonLoadingProvider.notifier).state = false;
        ref.read(otpErrorProvider.notifier).state =
            response.message ?? texts.otpVerificationFailed;
        ref.read(otpInputProvider.notifier).state = '';
      }
    } catch (e, stackTrace) {
      debugPrint('OTP Error: $e');
      debugPrint('Stack Trace:\n$stackTrace');
      ref.read(otpErrorProvider.notifier).state = texts.somethingWentWrong;
      ref.read(isButtonLoadingProvider.notifier).state = false;
    } finally {
      ref.read(isButtonLoadingProvider.notifier).state = false;
    }
  }

  Future<void> resendLoginOtp(BuildContext context) async {
    final cellNo = ref.read(phoneInputProvider);
    final remainingTime = ref.read(otpTimerProvider);
    final texts = ref.read(appTextsProvider);

    if (remainingTime > 0) return;

    ref.read(otpErrorProvider.notifier).state = null;

    try {
      final response = await ref.read(loginUseCaseProvider).call(cellNo);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(texts.otpResentSuccessfully)),
        );
        ref.read(otpTimerProvider.notifier).reset();
      } else {
        ref.read(otpErrorProvider.notifier).state =
            response.message ?? texts.failedToResendOtp;
      }
    } catch (e) {
      debugPrint("Resend OTP Error: $e");
      ref.read(otpErrorProvider.notifier).state =
          texts.somethingWentWrongWhileResendingOtp;
    }
  }
}
