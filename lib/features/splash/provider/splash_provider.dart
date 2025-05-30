import 'package:growk_v2/views.dart';

final splashNavigatorProvider = Provider((ref) => SplashNavigator(ref));

class SplashNavigator {
  final Ref ref;
  SplashNavigator(this.ref);

  Future<void> startTimer(BuildContext context, WidgetRef ref) async {
    await Future.delayed(const Duration(seconds: 2));

    final accessToken = SharedPreferencesHelper.getString("access_token");
    final refreshToken = SharedPreferencesHelper.getString("refresh_token");
    final idToken = SharedPreferencesHelper.getString("id_token");
    final phoneNumber = SharedPreferencesHelper.getString("phone_number");
    final isNewUser = SharedPreferencesHelper.getBool("is_new_user");

    if (accessToken != null && accessToken.isNotEmpty) {
      ref.read(userDataProvider.notifier).state = UserDataModel(
        accessToken: accessToken,
        refreshToken: refreshToken,
        idToken: idToken,
        isNewUser: isNewUser,
        phoneNumber: phoneNumber,
      );

      await ref.read(userProfileControllerProvider).getUserProfile(ref);

      final profile = ref.read(userProfileStateProvider).userData;

      if (profile?.profileCompletion == 1) {
        ref.read(bottomNavBarProvider.notifier).state = 0;
        Navigator.pushReplacementNamed(context, AppRouter.mainScreen);
      } else {
        ref.read(bottomNavBarProvider.notifier).state = 0;
        Navigator.pushReplacementNamed(
            context, AppRouter.editUserDetailsScreen);
      }
    } else {
      Navigator.pushReplacementNamed(context, AppRouter.login);
    }
  }
}
