import '../../../views.dart';
import 'package:growk_v2/features/bank_details/provider/bank_otp_provider.dart' as bank;

class BankOtpController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;

  BankOtpController(this.ref) : super(const AsyncData(null));

  Future<void> verifyOtp(String otp, BuildContext context,
      WidgetRef ref) async {
    final errorNotifier = ref.read(bank.otpErrorProvider.notifier);

    if (otp.isEmpty || otp.length != 4) {
      errorNotifier.state = 'Please enter a valid 4-digit OTP.';
      return;
    }

    state = const AsyncLoading();
    errorNotifier.state = null;

    final data = ref.read(bankDetailsControllerProvider.notifier)
        .getBankDetails();
    final useCase = BankOtpUseCase(ref.read(bank.bankOtpRepoProvider));

    try {
      final response = await useCase(otp, data);

      if (response.isSuccess) {
        await ref.read(userProfileControllerProvider).refreshUserProfile(ref);

        Navigator.of(context).pop(); // ✅ close OTP sheet
        Navigator.of(context).pop(); // ✅ close bank form screen

        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Bank details verified successfully!',
          type: SnackType.success,
        );

        state = const AsyncData(null);
      } else {
        final errorMsg = response.message ?? 'Invalid OTP';
        errorNotifier.state = errorMsg;

        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: errorMsg,
          type: SnackType.error,
        );

        state = AsyncError(errorMsg, StackTrace.current);
      }
    } catch (e) {
      const fallbackError = 'Something went wrong. Please try again.';
      errorNotifier.state = fallbackError;

      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: fallbackError,
        type: SnackType.error,
      );

      state = AsyncError(e, StackTrace.current);
    }
  }
}
  final bankOtpControllerProvider =
StateNotifierProvider<BankOtpController, AsyncValue<void>>(
      (ref) => BankOtpController(ref),
);
