import '../../../../views.dart';

class ApplyRefCodeSubmit extends ConsumerWidget {
  const ApplyRefCodeSubmit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isSubmittingProvider);
    final controller = ref.read(applyRefCodeControllerProvider);

    void navigateToHome() {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRouter.editUserDetailsScreen,
            (route) => false,
      );
    }

    return ScalingFactor(
      child: ReusableColumn(
        children: <Widget>[
          const ReusableSizedBox(height: 220),

          SkipButton(
            title: 'Skip',
            onTap: navigateToHome,
          ),

          const ReusableSizedBox(height: 15),

          GrowkButton(
            title:'Apply',
            onTap: isLoading
                ? null
                : () async {
              final success = await controller.submit(context);
              if (success) navigateToHome();
            },
          ),
        ],
      ),
    );
  }
}
