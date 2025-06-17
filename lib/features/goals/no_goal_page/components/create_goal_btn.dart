import 'package:growk_v2/views.dart';

Widget createGoalButton({
  required BuildContext context,
  required WidgetRef ref,
  VoidCallback? onGoalCreated,
}) {
  final profileState = ref.watch(userProfileStateProvider);
  final userData = profileState.userData;
  return GrowkButton(
    title: 'Create Your First Goal',
    onTap: userData?.kycVerified == false
        ? () {
            showGrowkSnackBar(
              context: context,
              ref: ref,
              message: 'Please verify your KYC details for adding goals',
              type: SnackType.error,
            );

            Navigator.pushNamed(context, AppRouter.kycVerificationScreen);
          }
        : () async {
            await Navigator.pushNamed(context, AppRouter.addGoalPage);

            if (onGoalCreated != null) {
              onGoalCreated();
            }
          },
  );
}
