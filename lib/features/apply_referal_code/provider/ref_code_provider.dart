import '../../../views.dart';
import '../controller/apply_ref_code_controller.dart';

// Holds the referral code text
final referralCodeProvider = StateProvider<String>((ref) => '');

// Holds the error message for the referral code field
final referralValidationProvider = StateProvider<String?>((ref) => null);

// Manages the loading state during submission
final isSubmittingProvider = StateProvider<bool>((ref) => false);

// Provides an instance of ApplyRefCodeController
final applyRefCodeControllerProvider = Provider<ApplyRefCodeController>(
      (ref) => ApplyRefCodeController(ref),
);
