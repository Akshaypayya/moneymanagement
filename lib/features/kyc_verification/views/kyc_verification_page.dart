import 'package:growk_v2/features/kyc_verification/views/widgets/kyc_description.dart';
import 'package:growk_v2/features/kyc_verification/views/widgets/kyc_vector_image.dart';
import 'package:growk_v2/features/kyc_verification/views/widgets/kyc_verification_button.dart';
import 'package:growk_v2/features/kyc_verification/views/widgets/kyc_verification_form.dart';
import 'package:growk_v2/views.dart';
class KycVerificationPage extends ConsumerWidget {
  const KycVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          ref.read(kycControllerProvider.notifier).clearErrorProviders(ref);
        }
      },
      child: ScalingFactor(
        child: CustomScaffold(
          backgroundColor: AppColors.current(isDark).background,
          appBar: GrowkAppBar(title: 'KYC verification', isBackBtnNeeded: true),
          body:SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child:  ReusableColumn(
              children: [
                KycVectorImage(),
                KycDescription(isDark: isDark,),
                ReusableSizedBox(height: 50,),
                KycVerificationForm(),
                ReusableSizedBox(height: 150,),
                KycVerificationButton()
              ],
            ),
          ),
          // bottomNavigationBar: const ,
        ),
      ),
    );
  }
}
