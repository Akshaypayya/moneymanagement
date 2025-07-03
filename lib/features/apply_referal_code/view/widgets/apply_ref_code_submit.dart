import '../../../../views.dart';

class ApplyRefCodeSubmit extends ConsumerWidget {
  const ApplyRefCodeSubmit({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isSubmittingProvider);
    final controller = ref.read(applyRefCodeControllerProvider);
    final texts = ref.watch(appTextsProvider);

    void navigateToHome() {
      ref.read(editUserControllerProvider).setDefaults(ref);
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
            title: texts.skip,
            onTap: navigateToHome,
          ),

          const ReusableSizedBox(height: 15),

          GrowkButton(
            title: texts.applyReferral,
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
