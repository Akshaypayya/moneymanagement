import 'package:money_mangmnt/views.dart';

class UserProfileNotifier extends StateNotifier<UserProfileModel?> {
  UserProfileNotifier() : super(null);

  void setProfile(UserProfileModel model) {
    state = model;
  }

  void clearProfile() {
    state = null;
  }

  void prefillBankDetailsControllers(WidgetRef ref) {
    if (state?.bankDetails.isNotEmpty == true) {
      final bankDetails = state!.bankDetails;

      ref.read(bankNameControllerProvider).text =
          bankDetails['nameOnAcc'] ?? '';
      ref.read(bankIbanControllerProvider).text = bankDetails['accNo'] ?? '';
      ref.read(bankReIbanControllerProvider).text = bankDetails['accNo'] ?? '';
    }
  }
}
