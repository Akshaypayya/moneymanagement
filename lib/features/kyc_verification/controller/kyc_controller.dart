import 'package:growk_v2/core/widgets/common_dialog_box.dart';
import 'package:growk_v2/features/kyc_verification/use_case/kyc_use_case.dart';
import 'package:growk_v2/views.dart';

class KYCController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {
    // No initial logic needed here for now
  }
  void clearErrorProviders(WidgetRef ref) {
    ref.read(kycIdErrorProvider.notifier).state = null;
    state = const AsyncData(null); // clear any AsyncError state
  }


  Future<void> submitForm(BuildContext context, WidgetRef ref) async {
    final loadingNotifier = ref.read(isButtonLoadingProvider.notifier);
    loadingNotifier.state = true;

    final id = ref.read(kycIdControllerProvider).text.trim();
    final errorProvider = ref.read(kycIdErrorProvider.notifier);

    // Check if ID is exactly 10 digits and starts with 1 or 2
    if (!RegExp(r'^\d{10}$').hasMatch(id) || !(id.startsWith('1') || id.startsWith('2'))) {
      final errorMessage = 'National ID or Iqama must be 10 digits and start with 1 or 2.';
      state = AsyncError(errorMessage, StackTrace.current);
      errorProvider.state = errorMessage;
      loadingNotifier.state = false;
      return;
    }

    try {
      final repo = ref.read(kycRepoProvider);
      final useCase = UploadKYCUseCase(repo);

      await useCase.call(kycData: {"idNumber": id});
      await ref.read(userProfileControllerProvider).refreshUserProfile(ref);
      loadingNotifier.state = false;
      // Show dialog but do NOT await it here, so dialog stays open
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => CommonDialog(
          title: 'Complete Verification in Nafath App',
          content: 'A request has been sent to your Nafath app. Please open it and tap the number shown to securely complete your KYC verification via Saudi digital identity services.',
          positiveButtonText: 'Got it',
          number: '76',
          onPositivePressed: () {
          },
        ),
      );

      // Now do your automatic process that when completed will close the dialog:
      await Future.delayed(Duration(seconds: 3)).whenComplete(
        () => Navigator.of(context).pop(),
      );

      // Then close dialog programmatically:
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(); // closes the dialog automatically when process done
      }

      // Then show success snackbar:
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'KYC submitted successfully!',
        type: SnackType.success,
      );

    } catch (e, st) {
      state = AsyncError(e.toString(), st);
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'KYC submission failed. Try again.',
        type: SnackType.error,
      );
    } finally {
    }
  }
}
