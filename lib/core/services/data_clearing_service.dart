// import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_detail_controller.dart';
// import 'package:growk_v2/features/referral_rewards/provider/referrel_rewards_notifier.dart';
// import 'package:growk_v2/views.dart';

// class ProviderResetService {
//   void clearAll(WidgetRef ref) {
//     ref.invalidate(userProfileProvider);
//     ref.invalidate(genderProvider);
//     ref.invalidate(dobProvider);
//     ref.invalidate(dobUiProvider);
//     ref.invalidate(nomineeDobUIProvider);
//     ref.invalidate(nameErrorProvider);
//     ref.invalidate(emailErrorProvider);
//     ref.invalidate(genderErrorProvider);
//     ref.invalidate(dobErrorProvider);
//     ref.invalidate(imageErrorProvider);
//     ref.invalidate(profilePictureFileProvider);
//     ref.invalidate(profilePictureUploadStateProvider);
//     ref.invalidate(userProfileStateProvider);
//     ref.invalidate(isButtonLoadingProvider);
//     ref.invalidate(editUserControllerProvider);
//     ref.invalidate(homeDetailsProvider);
//     ref.invalidate(getHomeDetailsProvider);
//     ref.invalidate(totalSavingsProvider);
//     ref.invalidate(goldWeightProvider);
//     ref.invalidate(homeControllerProvider);
//     ref.invalidate(getHomeDetailsUseCaseProvider);
//     ref.invalidate(getHomeDetailsRepoProvider);
//     ref.invalidate(referralCodeProvider);
//     ref.invalidate(referralValidationProvider);
//     ref.invalidate(isSubmittingProvider);
//     ref.invalidate(applyRefCodeControllerProvider);
//     ref.invalidate(otpInputProvider);
//     ref.invalidate(otpErrorProvider);
//     ref.invalidate(otpTimerProvider);
//     ref.invalidate(phoneInputProvider);
//     ref.invalidate(isButtonLoadingProvider);
//     ref.invalidate(kycIdErrorProvider);
//     ref.read(bottomNavBarProvider.notifier).state = 0;
//     ref.invalidate(goalDetailRepositoryProvider); //goal detail repository
//     ref.invalidate(goalDetailStateProvider);
//     ref.invalidate(notificationProvider);
//   }
// }

// final providerResetServiceProvider = Provider((ref) => ProviderResetService());
import 'package:growk_v2/core/biometric/biometeric_setting_provider.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_detail_controller.dart';
import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/features/notifcation_page/provider/notification_provider.dart';
import 'package:growk_v2/features/referral_rewards/provider/referrel_rewards_notifier.dart';
import 'package:growk_v2/views.dart';

class ProviderResetService {
  void clearAll(WidgetRef ref) {
    // User/Profile
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

    // Home
    ref.invalidate(homeDetailsProvider);
    ref.invalidate(getHomeDetailsProvider);
    ref.invalidate(totalSavingsProvider);
    ref.invalidate(goldWeightProvider);
    ref.invalidate(homeControllerProvider);
    ref.invalidate(getHomeDetailsUseCaseProvider);
    ref.invalidate(getHomeDetailsRepoProvider);

    // Referral
    ref.invalidate(referralCodeProvider);
    ref.invalidate(referralValidationProvider);
    ref.invalidate(isSubmittingProvider);
    ref.invalidate(applyRefCodeControllerProvider);

    // OTP/Auth
    ref.invalidate(otpInputProvider);
    ref.invalidate(otpErrorProvider);
    ref.invalidate(otpTimerProvider);
    ref.invalidate(phoneInputProvider);
    ref.invalidate(isButtonLoadingProvider);
    ref.invalidate(kycIdErrorProvider);

    // Navigation
    ref.read(bottomNavBarProvider.notifier).state = 0;

    // Goal Detail
    ref.invalidate(goalDetailRepositoryProvider);
    ref.invalidate(goalDetailStateProvider);

    // Goal List & Pagination
    ref.invalidate(goalListRepositoryProvider);
    ref.invalidate(goalListStateProvider);
    ref.invalidate(goalListPaginatedStateProvider);

    // Goal Add
    ref.invalidate(goalNameProvider);
    ref.invalidate(selectedGoalIconProvider);
    ref.invalidate(selectedImageFileProvider);
    ref.invalidate(autoDepositProvider);
    ref.invalidate(calculatedYearProvider);
    ref.invalidate(calculatedAmountProvider);

    // Transactions (main transaction page)
    ref.invalidate(paginatedTransactionProvider);
    ref.invalidate(transactionRepositoryProvider);

    // Wallet
    ref.invalidate(walletBalanceProvider);

    // Biometric
    ref.invalidate(biometricEnabledProvider);
    // Notifications
    ref.invalidate(notificationProvider);
    ref.invalidate(notificationStateProvider);

    // Referral Rewards
    ref.invalidate(referralRewardsProvider);
  }
}

final providerResetServiceProvider = Provider((ref) => ProviderResetService());
