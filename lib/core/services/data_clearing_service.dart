import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_detail_controller.dart';
import 'package:growk_v2/features/referral_rewards/provider/referrel_rewards_notifier.dart';
import 'package:growk_v2/views.dart';

class ProviderResetService {
  void clearAll(WidgetRef ref) {
    ref.invalidate(userProfileProvider);
    ref.invalidate(genderProvider);
    ref.invalidate(dobProvider);
    ref.invalidate(dobUiProvider);
    ref.invalidate(nomineeDobUIProvider);
    ref.invalidate(nameErrorProvider);
    ref.invalidate(emailErrorProvider);
    ref.invalidate(genderErrorProvider);
    ref.invalidate(dobErrorProvider);
    ref.invalidate(imageErrorProvider);
    ref.invalidate(profilePictureFileProvider);
    ref.invalidate(profilePictureUploadStateProvider);
    ref.invalidate(userProfileStateProvider);
    ref.invalidate(isButtonLoadingProvider);
    ref.invalidate(editUserControllerProvider);
    ref.invalidate(homeDetailsProvider);
    ref.invalidate(getHomeDetailsProvider);
    ref.invalidate(totalSavingsProvider);
    ref.invalidate(goldWeightProvider);
    ref.invalidate(homeControllerProvider);
    ref.invalidate(getHomeDetailsUseCaseProvider);
    ref.invalidate(getHomeDetailsRepoProvider);
    ref.invalidate(referralCodeProvider);
    ref.invalidate(referralValidationProvider);
    ref.invalidate(isSubmittingProvider);
    ref.invalidate(applyRefCodeControllerProvider);
    ref.invalidate(otpInputProvider);
    ref.invalidate(otpErrorProvider);
    ref.invalidate(otpTimerProvider);
    ref.invalidate(phoneInputProvider);
    ref.invalidate(isButtonLoadingProvider);
    ref.invalidate(kycIdErrorProvider);
    ref.read(bottomNavBarProvider.notifier).state = 0;
    ref.invalidate(goalDetailRepositoryProvider); //goal detail repository
    ref.invalidate(goalDetailStateProvider);
  }
}

final providerResetServiceProvider = Provider((ref) => ProviderResetService());
