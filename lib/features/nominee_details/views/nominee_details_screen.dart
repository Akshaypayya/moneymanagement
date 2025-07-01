import 'package:growk_v2/views.dart';

class NomineeDetailsScreen extends ConsumerWidget {
  const NomineeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(nomineeDetailsControllerProvider);
    final isDark = ref.watch(isDarkProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          controller.clearErrorProviders();
        }
      },
      child: ScalingFactor(
        child: CustomScaffold(
          backgroundColor: AppColors.current(isDark).background,
          appBar: GrowkAppBar(
            title: 'Nominee Details',
            isBackBtnNeeded: true,
            onBack: () {
              controller.clearFields();
              Navigator.of(context).pop();
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),

            child: const ReusableColumn(children: [
              CommonTitleAndDescription(
                title: 'Add Nominee Details',
                description: 'Provide nominee information to safeguard your assets. Accurate nominee details help ensure rightful claims in case of unforeseen events.',
              ),
              ReusableSizedBox(
                height: 15,
              ),
              NomineeDetailsForm(),
            ]),
          ),
          bottomNavigationBar: const NomineeDetailsButton(),
        ),
      ),
    );
  }
}
