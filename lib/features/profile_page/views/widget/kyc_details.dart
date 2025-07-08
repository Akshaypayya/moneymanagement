import 'package:growk_v2/features/profile_page/views/widget/profile_info_item.dart';
import 'package:growk_v2/views.dart';

Widget kycDetails({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final userData = profileState.userData;
  final texts = ref.watch(appTextsProvider);
  return userData == null
      ? ProfileDetailItem(
          label: texts.kycDetails,
          value: texts.tapToAddKyc,
          isSuffixIconNeeded: true,
          onTap: () =>
              Navigator.pushNamed(context, AppRouter.kycVerificationScreen),
        )
      : ProfileDetailItem(
          label: texts.kycVerification,
          value:
              userData.kycVerified == true ? texts.verified : texts.notVerified,
          isSuffixIconNeeded: userData.kycVerified == true ? false : true,
          suffixWidget: userData.kycVerified == true
              ? Image.asset(
                  'assets/verified.png',
                  height: 20,
                )
              : null,
          onTap: userData.kycVerified == true
              ? null
              : () =>
                  Navigator.pushNamed(context, AppRouter.kycVerificationScreen),
        );
}
