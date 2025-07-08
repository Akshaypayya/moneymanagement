import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppTextsString {
  final AppLocalizations? _localizations;

  AppTextsString(this._localizations);
  factory AppTextsString.empty() => AppTextsString(null);

  String get changeLanguage => _localizations?.changeLanguage ?? "";
  String get continueText => _localizations?.continueButton ?? "";
  String get welcomeBack => _localizations?.welcomeBack ?? "";
  String get loginTopDescription => _localizations?.loginTopDescription ?? "";
  String get enterYourMobileNumber =>
      _localizations?.enterYourMobileNumber ?? "";
  String get mobileNumberHint => _localizations?.mobileNumberHint ?? "";
  String get mobileNumberRequired => _localizations?.mobileNumberRequired ?? "";
  String get invalidMobileNumber => _localizations?.invalidMobileNumber ?? "";
  String get loginBottomDescription =>
      _localizations?.loginBottomDescription ?? '';
  String get enterOtpToProceed => _localizations?.enterOtpToProceed ?? '';
  String get otpSentMessage => _localizations?.otpSentMessage ?? '';
  String get otpVerifyInstruction => _localizations?.otpVerifyInstruction ?? '';
  String get enterOtpToVerify => _localizations?.enterOtpToVerify ?? '';
  String get didntReceiveOtp => _localizations?.didntReceiveOtp ?? '';
  String resendIn(int seconds) => _localizations?.resendIn(seconds) ?? '';
  String get resendNow => _localizations?.resendNow ?? '';
  String get pleaseEnterFullOtp => _localizations?.pleaseEnterFullOtp ?? '';
  String get authenticateBiometric =>
      _localizations?.authenticateBiometric ?? '';

  String get biometricEnabled => _localizations?.biometricEnabled ?? '';
  String get biometricFailed => _localizations?.biometricFailed(error) ?? '';
  String get enableBiometricFailed =>
      _localizations?.enableBiometricFailed ?? '';
  String get biometricDisabled => _localizations?.biometricDisabled ?? '';
  String get bioCheckAvail => _localizations?.bioCheckAvail ?? '';
  String get bioNotAvail => _localizations?.bioNotAvail ?? '';
  String get bioAuth => _localizations?.bioAuth ?? '';
  String get fingerprintSubtitle => _localizations?.fingerprintSubtitle ?? '';
  String get fingerprint => _localizations?.fingerprint ?? '';
  String get growkVersion => _localizations?.growkVersion ?? '';
  String get growkVersionSubtitle => _localizations?.growkVersionSubtitle ?? '';
  String get growkDescription => _localizations?.growkDescription ?? '';

  String get otpVerificationFailed =>
      _localizations?.otpVerificationFailed ?? '';
  String get somethingWentWrong => _localizations?.somethingWentWrong ?? '';
  String get otpResentSuccessfully =>
      _localizations?.otpResentSuccessfully ?? '';
  String get failedToResendOtp => _localizations?.failedToResendOtp ?? '';
  String get somethingWentWrongWhileResendingOtp =>
      _localizations?.somethingWentWrongWhileResendingOtp ?? '';
  String get editUserDetails => _localizations?.editUserDetails ?? "";
  String get nameLabel => _localizations?.nameLabel ?? "";
  String get enterFullName => _localizations?.enterFullName ?? "";
  String get emailLabel => _localizations?.emailLabel ?? "";
  String get enterEmail => _localizations?.enterEmail ?? "";
  String get genderLabel => _localizations?.genderLabel ?? "";
  String get selectGender => _localizations?.selectGender ?? "";
  String get dobLabel => _localizations?.dobLabel ?? "";
  String get selectDob => _localizations?.selectDob ?? "";
  String get saveButton => _localizations?.saveButton ?? "";
  String get applyReferralCodeTitle =>
      _localizations?.applyReferralCodeTitle ?? "";
  String get applyReferralCodeDescription =>
      _localizations?.applyReferralCodeDescription ?? "";
  String get enterReferralCodeLabel =>
      _localizations?.enterReferralCodeLabel ?? "";
  String get referralCodeHint => _localizations?.referralCodeHint ?? "";
  String get skip => _localizations?.skip ?? '';
  String get applyReferral => _localizations?.applyReferral ?? '';
  String get totalSavings => _localizations?.totalSavings ?? "";
  String get walletBalance => _localizations?.walletBalance ?? "";
  String get goldSavingsAsOf => _localizations?.goldSavingsAsOf ?? "";
  String get kycNotVerified => _localizations?.kycNotVerified ?? "";
  String get genericError => _localizations?.genericError ?? "";
  String get error => _localizations?.error ?? "";
  String get settings => _localizations?.settings ?? "";
  String get notification => _localizations?.notification ?? "";
  String get notificationSubtitle => _localizations?.notificationSubtitle ?? "";
  String get language => _localizations?.language ?? "";
  String get languageSubtitle => _localizations?.languageSubtitle ?? "";
  String get theme => _localizations?.theme ?? "";
  String get themeSubtitle => _localizations?.themeSubtitle ?? "";
  String get faq => _localizations?.faq ?? "";
  String get faqSubtitle => _localizations?.faqSubtitle ?? "";
  String get termsAndConditions => _localizations?.termsAndConditions ?? "";
  String get termsSubtitle => _localizations?.termsSubtitle ?? "";
  String get about => _localizations?.about ?? "";
  String get aboutSubtitle => _localizations?.aboutSubtitle ?? "";
  String get logout => _localizations?.logout ?? "";
  String get logoutSubtitle => _localizations?.logoutSubtitle ?? "";
  String get english => _localizations?.english ?? "";
  String get arabic => _localizations?.arabic ?? "";
  String get notificationsEnabled => _localizations?.notificationsEnabled ?? "";
  String get notificationsDisabled =>
      _localizations?.notificationsDisabled ?? "";
  String get goalDetails => _localizations?.goalDetails ?? "";
  String get editGoal => _localizations?.editGoal ?? "";
  String get editGoalSubtitle => _localizations?.editGoalSubtitle ?? "";
  String get loadFunds => _localizations?.loadFunds ?? "";
  String get loadFundsSubtitle => _localizations?.loadFundsSubtitle ?? "";
  String get sellGold => _localizations?.sellGold ?? "";
  String get sellGoldSubtitle => _localizations?.sellGoldSubtitle ?? "";
  String get transactions => _localizations?.transactions ?? "";
  String get transactionsEmptyState =>
      _localizations?.transactionsEmptyState ?? "";
  String get allTransactionsLoaded =>
      _localizations?.allTransactionsLoaded ?? "";
  String get loading => _localizations?.loading ?? "";
  String get success => _localizations?.success ?? "";
  String get cancel => _localizations?.cancel ?? "";
  String get confirm => _localizations?.confirm ?? "";
  String get profile => _localizations?.profile ?? "";
  String get editProfile => _localizations?.editProfile ?? "";
  String get userName => _localizations?.userName ?? "";
  String get mobileNumber => _localizations?.mobileNumber ?? "";
  String get gender => _localizations?.gender ?? "";
  String get male => _localizations?.male ?? "";
  String get female => _localizations?.female ?? "";
  String get other => _localizations?.other ?? "";
  String get notSpecified => _localizations?.notSpecified ?? "";
  String get dateOfBirth => _localizations?.dateOfBirth ?? "";
  String get notAvailable => _localizations?.notAvailable ?? "";
  String get kycDetails => _localizations?.kycDetails ?? "";
  String get kycVerification => _localizations?.kycVerification ?? "";
  String get verified => _localizations?.verified ?? "";
  String get notVerified => _localizations?.notVerified ?? "";
  String get tapToAddKyc => _localizations?.tapToAddKyc ?? "";
  String get nomineeDetails => _localizations?.nomineeDetails ?? "";
  String get tapToAddNominee => _localizations?.tapToAddNominee ?? "";
  String get savedAddress => _localizations?.savedAddress ?? "";
  String get tapToAddAddress => _localizations?.tapToAddAddress ?? "";
  String get bankDetails => _localizations?.bankDetails ?? "";
  String get tapToAddBank => _localizations?.tapToAddBankDetails ?? "";
  String get tapToAddBankDetails => _localizations?.tapToAddBankDetails ?? "";
  String get verifyKycFirst => _localizations?.verifyKycFirst ?? "";
  String get noNomineeDetailsFound =>
      _localizations?.noNomineeDetailsFound ?? "";
  String get noTransactionsYet => _localizations?.noTransactionsYet ?? "";
  String get transactionHistoryHint =>
      _localizations?.transactionHistoryHint ?? "";
  String get retry => _localizations?.retry ?? "";
  String get loadingYourTransactions =>
      _localizations?.loadingYourTransactions ?? "";
  String get monthJanuary => _localizations?.monthJanuary ?? "";
  String get monthFebruary => _localizations?.monthFebruary ?? "";
  String get monthMarch => _localizations?.monthMarch ?? "";
  String get monthApril => _localizations?.monthApril ?? "";
  String get monthMay => _localizations?.monthMay ?? "";
  String get monthJune => _localizations?.monthJune ?? "";
  String get monthJuly => _localizations?.monthJuly ?? "";
  String get monthAugust => _localizations?.monthAugust ?? "";
  String get monthSeptember => _localizations?.monthSeptember ?? "";
  String get monthOctober => _localizations?.monthOctober ?? "";
  String get monthNovember => _localizations?.monthNovember ?? "";
  String get monthDecember => _localizations?.monthDecember ?? "";
  String get unknown => _localizations?.unknown ?? "";
  String get gm => _localizations?.gm ?? "";
}
