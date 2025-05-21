import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/features/profile_page/controller/user_detail_controller.dart';
import 'package:money_mangmnt/features/profile_page/model/user_details_model.dart';
import 'package:money_mangmnt/features/profile_page/model/user_profile_model.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_profile_notifier.dart';
import 'package:money_mangmnt/features/profile_page/repo/user_details_repo.dart';

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
});

final userProfileRepositoryProvider = Provider<UserDetailRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return UserDetailRepository(networkService, ref);
});
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfileModel?>(
  (ref) => UserProfileNotifier(),
);

final userProfileControllerProvider = Provider<UserProfileController>((ref) {
  final repository = ref.watch(userProfileRepositoryProvider);
  return UserProfileController(repository);
});

enum UserProfileStatus { initial, loading, success, error }

class UserProfileState {
  final UserProfileStatus status;
  final UserData? userData;
  final SavedAddress? savedAddress;
  final BankDetails? bankDetails;
  final NomineeDetails? nomineeDetails;
  final String? errorMessage;

  UserProfileState({
    this.status = UserProfileStatus.initial,
    this.userData,
    this.errorMessage,
    this.savedAddress,
    this.bankDetails,
    this.nomineeDetails,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserData? userData,
    String? errorMessage,
    SavedAddress? savedAddress,
    BankDetails? bankDetails,
    NomineeDetails? nomineeDetails,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      userData: userData ?? this.userData,
      errorMessage: errorMessage ?? this.errorMessage,
      savedAddress: savedAddress ?? this.savedAddress,
      bankDetails: bankDetails ?? this.bankDetails,
      nomineeDetails: nomineeDetails ?? this.nomineeDetails,
    );
  }
}

class UserProfileStateNotifier extends StateNotifier<UserProfileState> {
  UserProfileStateNotifier() : super(UserProfileState());

  void setLoading() {
    state = state.copyWith(status: UserProfileStatus.loading);
  }

  void setSuccess(UserData userData) {
    state = state.copyWith(
      status: UserProfileStatus.success,
      userData: userData,
      savedAddress: userData.savedAddress,
      bankDetails: userData.bankDetails,
      nomineeDetails: userData.nomineeDetails,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: UserProfileStatus.error,
      errorMessage: message,
    );
  }

  void reset() {
    state = UserProfileState();
  }
}

final userProfileStateProvider =
    StateNotifierProvider<UserProfileStateNotifier, UserProfileState>((ref) {
  return UserProfileStateNotifier();
});
