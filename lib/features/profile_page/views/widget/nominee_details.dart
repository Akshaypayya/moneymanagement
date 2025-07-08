import 'package:growk_v2/features/profile_page/views/widget/profile_format_fns.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_info_section.dart';
import 'package:growk_v2/views.dart';

Widget nomineeDetails({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final nomineeData = profileState.nomineeDetails;
  final userData = profileState.userData;
  final texts = ref.watch(appTextsProvider);
  return nomineeData == null
      ? ProfileNavigationItem(
          label: texts.nomineeDetails,
          value1: texts.tapToAddNominee,
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
                  Navigator.pushNamed(context, AppRouter.nomineeDetailsScreen),
        )
      : ProfileNavigationItem(
          label: texts.nomineeDetails,
          value1:
              '${nomineeData.nomineeName}, ${nomineeData.nomineeRelation}, ${profileFormatDate(nomineeData.nomineeDob)}' ??
                  texts.noNomineeDetailsFound,
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
                  Navigator.pushNamed(context, AppRouter.nomineeDetailsScreen),
        );
}
