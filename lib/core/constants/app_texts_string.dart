import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppTextsString {
  final AppLocalizations? _localizations;

  AppTextsString(this._localizations);
  factory AppTextsString.empty() => AppTextsString(null);

  String get changeLanguage => _localizations?.changeLanguage ?? "";
  String get continueText => _localizations?.continueButton ?? "";
  String get welcomeBack => _localizations?.welcomeBack ?? "";
  String get loginTopDescription => _localizations?.loginTopDescription ?? "";
  String get enterYourMobileNumber => _localizations?.enterYourMobileNumber ?? "";
  String get mobileNumberHint => _localizations?.mobileNumberHint ?? "";
  String get mobileNumberRequired => _localizations?.mobileNumberRequired ?? "";
  String get invalidMobileNumber => _localizations?.invalidMobileNumber ?? "";
  String get loginBottomDescription => _localizations?.loginBottomDescription??'';
  String get enterOtpToProceed => _localizations?.enterOtpToProceed??'';
  String get otpSentMessage => _localizations?.otpSentMessage??'';
  String get otpVerifyInstruction => _localizations?.otpVerifyInstruction??'';
  String get enterOtpToVerify => _localizations?.enterOtpToVerify??'';
  String get didntReceiveOtp => _localizations?.didntReceiveOtp??'';
  String resendIn(int seconds) => _localizations?.resendIn(seconds)??'';
  String get resendNow => _localizations?.resendNow??'';
  String get pleaseEnterFullOtp => _localizations?.pleaseEnterFullOtp??'';
  String get authenticateBiometric => _localizations?.authenticateBiometric??'';
  String get biometricEnabled => _localizations?.biometricEnabled??'';
  String biometricFailed(String error) => _localizations?.biometricFailed(error)??'';
  String get otpVerificationFailed => _localizations?.otpVerificationFailed??'';
  String get somethingWentWrong => _localizations?.somethingWentWrong??'';
  String get otpResentSuccessfully => _localizations?.otpResentSuccessfully??'';
  String get failedToResendOtp => _localizations?.failedToResendOtp??'';
  String get somethingWentWrongWhileResendingOtp => _localizations?.somethingWentWrongWhileResendingOtp??'';
  String get editUserDetails => _localizations?.editUserDetails??"";
  String get nameLabel => _localizations?.nameLabel??"";
  String get enterFullName => _localizations?.enterFullName??"";
  String get emailLabel => _localizations?.emailLabel??"";
  String get enterEmail => _localizations?.enterEmail??"";
  String get genderLabel => _localizations?.genderLabel??"";
  String get selectGender => _localizations?.selectGender??"";
  String get dobLabel => _localizations?.dobLabel??"";
  String get selectDob => _localizations?.selectDob??"";
  String get saveButton => _localizations?.saveButton??"";
  String get applyReferralCodeTitle => _localizations?.applyReferralCodeTitle??"";
  String get applyReferralCodeDescription => _localizations?.applyReferralCodeDescription??"";
  String get enterReferralCodeLabel => _localizations?.enterReferralCodeLabel??"";
  String get referralCodeHint => _localizations?.referralCodeHint??"";
  String get skip => _localizations?.skip??'';
  String get applyReferral => _localizations?.applyReferral??'';

}
