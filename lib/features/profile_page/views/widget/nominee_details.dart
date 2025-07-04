import 'package:growk_v2/features/profile_page/views/widget/profile_format_fns.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_info_section.dart';
import 'package:growk_v2/views.dart';

Widget nomineeDetails({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final nomineeData = profileState.nomineeDetails;
  final userData = profileState.userData;
  return nomineeData == null
      ? ProfileNavigationItem(
          label: 'Nominee Details',
          value1: 'Tap to add Nominee Details',
          isValue2Needed: false,
          isValue3Needed: false,
          onTap: userData?.kycVerified == false
              ? () => showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: 'Please verify your KYC details first',
                    type: SnackType.error,
                  )
              : () =>
                  Navigator.pushNamed(context, AppRouter.nomineeDetailsScreen),
        )
      : ProfileNavigationItem(
          label: 'Nominee Details',
          value1:
              '${nomineeData.nomineeName}, ${nomineeData.nomineeRelation}, ${profileFormatDate(nomineeData.nomineeDob)}' ??
                  "no nominee details found",
          isValue2Needed: false,
          isValue3Needed: false,
          onTap: userData?.kycVerified == false
              ? () => showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: 'Please verify your KYC details first',
                    type: SnackType.error,
                  )
              : () =>
                  Navigator.pushNamed(context, AppRouter.nomineeDetailsScreen),
        );
}
