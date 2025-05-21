import 'package:money_mangmnt/features/profile_page/views/widget/profile_info_item.dart';
import 'package:money_mangmnt/views.dart';

Widget kycDetails({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final userData = profileState.userData;
  return userData == null
      ? ProfileDetailItem(
          label: 'KYC Details',
          value: 'Tap to add KYC Details',
          isSuffixIconNeeded: true,
          onTap: () =>
              Navigator.pushNamed(context, AppRouter.kycVerificationScreen),
        )
      : ProfileDetailItem(
          label: 'KYC Verification',
          value: userData.kycVerified == true ? 'Verified' : 'Not Verified',
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
