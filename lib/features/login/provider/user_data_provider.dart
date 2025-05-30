import 'package:growk_v2/views.dart';

final userDataProvider = StateNotifierProvider<UserDataNotifier, UserDataModel>((ref) {
  return UserDataNotifier();
});

class UserDataModel {
  final String? accessToken;
  final String? refreshToken;
  final String? idToken;
  final bool? isNewUser;
  final String? phoneNumber;

  UserDataModel({
    this.accessToken,
    this.refreshToken,
    this.idToken,
    this.isNewUser,
    this.phoneNumber,
  });

  UserDataModel copyWith({
    String? accessToken,
    String? refreshToken,
    String? idToken,
    bool? isNewUser,
    String? phoneNumber,
  }) {
    return UserDataModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      idToken: idToken ?? this.idToken,
      isNewUser: isNewUser ?? this.isNewUser,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

class UserDataNotifier extends StateNotifier<UserDataModel> {
  UserDataNotifier() : super(UserDataModel());

  void setUserData(Map<String, dynamic> data, {required String phoneNumber}) {
    final accessToken = data['access_token'] as String?;
    final refreshToken = data['refresh_token'] as String?;
    final idToken = data['id_token'] as String?;
    final isNewUser = data['isNewUser'] as bool?;

    if (accessToken != null) SharedPreferencesHelper.saveString("access_token", accessToken);
    if (refreshToken != null) SharedPreferencesHelper.saveString("refresh_token", refreshToken);
    if (idToken != null) SharedPreferencesHelper.saveString("id_token", idToken);
    if (phoneNumber.isNotEmpty) SharedPreferencesHelper.saveString("phone_number", phoneNumber);
    if (isNewUser != null) SharedPreferencesHelper.saveBool("is_new_user", isNewUser);

    state = UserDataModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      idToken: idToken,
      isNewUser: isNewUser,
      phoneNumber: phoneNumber,
    );
  }

  void clear() {
    SharedPreferencesHelper.remove("access_token");
    SharedPreferencesHelper.remove("refresh_token");
    SharedPreferencesHelper.remove("id_token");
    SharedPreferencesHelper.remove("is_new_user");
    SharedPreferencesHelper.remove("phone_number");
    state = UserDataModel();
  }
}
