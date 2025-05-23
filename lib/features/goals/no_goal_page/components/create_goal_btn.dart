import 'package:money_mangmnt/views.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Please verify your KYC details for adding goals')));

            Navigator.pushNamed(context, AppRouter.kycVerificationScreen);
          }
        : () async {
            await Navigator.pushNamed(context, AppRouter.addGoalPage);

            // Trigger refresh when returning from goal creation
            if (onGoalCreated != null) {
              onGoalCreated();
            }
          },
  );
}
