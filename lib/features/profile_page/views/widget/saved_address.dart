import 'package:growk_v2/features/profile_page/views/widget/profile_info_section.dart';
import 'package:growk_v2/views.dart';

Widget savedAddress({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final addressData = profileState.savedAddress;
  final userData = profileState.userData;
  final texts = ref.watch(appTextsProvider);
  return addressData == null
      ? ProfileNavigationItem(
          label: texts.savedAddress,
          value1: texts.tapToAddAddress,
          isValue2Needed: false,
          isValue3Needed: false,
          onTap: userData?.kycVerified == false
              ? () => showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: texts.verifyKycFirst,
                    type: SnackType.error,
                  )
              : () =>
                  Navigator.pushNamed(context, AppRouter.savedAddressScreen),
        )
      : ProfileNavigationItem(
          label: texts.savedAddress,
          value1: addressData.streetAddress1 ?? texts.tapToAddAddress,
          value2: addressData.streetAddress1 == null ||
                  addressData.streetAddress2 == null
              ? ''
              : '${addressData.streetAddress2}, ${addressData.city}, ${addressData.state}, ${addressData.pinCode}',
          isValue2Needed: true,
          isValue3Needed: false,
          onTap: userData?.kycVerified == false
              ? () => showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: texts.verifyKycFirst,
                    type: SnackType.error,
                  )
              : () =>
                  Navigator.pushNamed(context, AppRouter.savedAddressScreen),
        );
}
