import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_info_section.dart';
import 'package:growk_v2/views.dart';

Widget bankDetails({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final bankData = profileState.bankDetails;
  final userData = profileState.userData;
  final texts = ref.watch(appTextsProvider);
  return bankData == null
      ? ProfileNavigationItem(
          label: texts.bankDetails,
          value1: texts.tapToAddBankDetails,
          isValue2Needed: false,
          isValue3Needed: false,
          onTap: userData?.kycVerified == false
              ? () => showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: texts.verifyKycFirst,
                    type: SnackType.error,
                  )
              : () => Navigator.pushNamed(context, AppRouter.bankDetailsScreen),
        )
      : Column(
          children: [
            GapSpace.height10,
            ProfileNavigationItem(
              label: texts.bankDetails,
              value1: '${bankData.nameOnAcc}, ${bankData.accNo.toString()}',
              value2:
                  '${bankData.ifsc}, ${bankData.nameOnAcc}, ${bankData.status}',
              onTap: userData?.kycVerified == false
                  ? () => showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message: texts.verifyKycFirst,
                        type: SnackType.error,
                      )
                  : () =>
                      Navigator.pushNamed(context, AppRouter.bankDetailsScreen),
            ),
          ],
        );
}
