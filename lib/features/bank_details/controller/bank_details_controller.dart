import 'package:growk_v2/features/bank_details/use_case/bank_use_case.dart';
import 'package:growk_v2/features/bank_details/use_case/update_bank_details_use_case.dart';
import 'package:growk_v2/features/bank_details/views/widgets/bank_otp_bottom_sheet.dart';
import '../../../views.dart';
class BankDetailsController extends StateNotifier<bool> {
  BankDetailsController(this.ref) : super(false);
  final Ref ref;

  bool validateForm(WidgetRef ref, BuildContext context) {
    final name = ref.read(bankNameControllerProvider).text.trim();
    final accNo = ref.read(bankIbanControllerProvider).text.trim().toUpperCase();
    final reAccNo = ref.read(bankReIbanControllerProvider).text.trim().toUpperCase();

    bool hasError = false;

    if (name.isEmpty) {
      ref.read(bankNameErrorProvider.notifier).state = 'Name is required';
      debugPrint("❌ Validation Failed: Name is empty");
      hasError = true;
    } else {
      ref.read(bankNameErrorProvider.notifier).state = null;
    }

    if (!isValidIBAN(accNo)) {
      ref.read(bankIbanErrorProvider.notifier).state = 'Invalid Saudi IBAN';
      debugPrint("❌ Validation Failed: IBAN is invalid → $accNo");
      hasError = true;
    } else {
      ref.read(bankIbanErrorProvider.notifier).state = null;
    }

    if (reAccNo != accNo) {
      ref.read(bankReIbanErrorProvider.notifier).state = 'IBANs do not match';
      debugPrint("❌ Validation Failed: Re-entered IBAN does not match → $reAccNo ≠ $accNo");
      hasError = true;
    } else {
      ref.read(bankReIbanErrorProvider.notifier).state = null;
    }

    if (!hasError) {
      debugPrint("✅ All Bank Details Validation Passed");
    }

    return !hasError;
  }

  void clearErrorProviders() {
    ref.read(bankNameErrorProvider.notifier).state = null;
    ref.read(bankIbanErrorProvider.notifier).state = null;
    ref.read(bankReIbanErrorProvider.notifier).state = null;
  }

  bool isValidIBAN(String iban) {
    if (iban.isEmpty || iban.length < 15 || iban.length > 24) return false;

    final cleaned = iban.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (!cleaned.startsWith('SA')) return false;

    final rearranged = cleaned.substring(4) + cleaned.substring(0, 4);

    final numeric = rearranged.split('').map((ch) {
      if (RegExp(r'\d').hasMatch(ch)) return ch;
      if (RegExp(r'[A-Z]').hasMatch(ch)) return (ch.codeUnitAt(0) - 'A'.codeUnitAt(0) + 10).toString();
      return '';
    }).join();

    try {
      final ibanInt = BigInt.parse(numeric);
      return ibanInt % BigInt.from(97) == BigInt.one;
    } catch (_) {
      return false;
    }
  }

  Map<String, String> getBankDetails() {
    return {
      "nameOnAcc": ref.read(bankNameControllerProvider).text.trim(),
      "accNo": ref.read(bankIbanControllerProvider).text.trim().toUpperCase(),
      "reAccNo": ref.read(bankReIbanControllerProvider).text.trim().toUpperCase(),
    };
  }

  Future<void> submitBankDetails(BuildContext context, WidgetRef ref) async {
    if (!validateForm(ref, context)) return;

    ref.read(isBankDetailsSubmittingProvider.notifier).state = true;

    final data = getBankDetails();
    final useCase = BankUseCase(ref.read(bankRepoProvider));

    try {
      final response = await useCase.call(data);

      if (response.isSuccess) {
        debugPrint("✅ Bank details submitted successfully");
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Bank details submitted successfully!',
          type: SnackType.success,
        );
        await showOtpBottomSheet(context, ref);
      } else if (response.isValidationFailed && response.data != null) {
        final serverErrors = response.data!;
        ref.read(bankNameErrorProvider.notifier).state = serverErrors['nameOnAcc'];
        ref.read(bankIbanErrorProvider.notifier).state = serverErrors['accNo'];
        ref.read(bankReIbanErrorProvider.notifier).state = serverErrors['reAccNo'];

        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Please correct the highlighted bank details.',
          type: SnackType.error,
        );
      } else if (response.status == 'Unauthorized' || response.message?.contains('401') == true) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Session expired. Please log in again.',
          type: SnackType.error,
        );
      } else {
        debugPrint("❌ Submission failed: ${response.message}");
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: response.message ?? 'Failed to submit bank details.',
          type: SnackType.error,
        );
      }
    } catch (e) {
      debugPrint("🚨 Exception during submission: $e");
      final isUnauthorized = e.toString().contains('401');
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: isUnauthorized
            ? 'Session expired. Please log in again.'
            : 'Something went wrong. Please try again.',
        type: SnackType.error,
      );
    } finally {
      ref.read(isBankDetailsSubmittingProvider.notifier).state = false;
    }
  }

  Future<void> updateBankDetails(BuildContext context, WidgetRef ref) async {
    if (!validateForm(ref, context)) return;

    final data = getBankDetails();
    final useCase = UpdateBankUseCase(ref.read(updateBankRepoProvider));

    try {
      final response = await useCase.call(data);

      if (response.isSuccess) {
        debugPrint("✅ Bank details updated successfully");
        await showOtpBottomSheet(context, ref);
      } else if (response.isValidationFailed && response.data != null) {
        final serverErrors = response.data!;
        ref.read(bankNameErrorProvider.notifier).state = serverErrors['nameOnAcc'];
        ref.read(bankIbanErrorProvider.notifier).state = serverErrors['accNo'];
        ref.read(bankReIbanErrorProvider.notifier).state = serverErrors['reAccNo'];

        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Please correct the highlighted bank details.',
          type: SnackType.error,
        );
      } else {
        debugPrint("❌ Update failed: ${response.message}");
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: response.message ?? 'Failed to update bank details.',
          type: SnackType.error,
        );
      }
    } catch (e) {
      debugPrint("🚨 Exception during update: $e");
      showGrowkSnackBar(
        context: context,
        ref: ref,
        message: 'Something went wrong. Please try again.',
        type: SnackType.error,
      );
    }
  }
}

final bankDetailsControllerProvider = StateNotifierProvider<BankDetailsController, bool>(
      (ref) => BankDetailsController(ref),
);
