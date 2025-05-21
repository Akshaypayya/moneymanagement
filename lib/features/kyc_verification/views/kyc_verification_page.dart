import 'package:money_mangmnt/features/kyc_verification/views/widgets/kyc_description.dart';
import 'package:money_mangmnt/features/kyc_verification/views/widgets/kyc_vector_image.dart';
import 'package:money_mangmnt/features/kyc_verification/views/widgets/kyc_verification_button.dart';
import 'package:money_mangmnt/features/kyc_verification/views/widgets/kyc_verification_form.dart';
import 'package:money_mangmnt/views.dart';

class KycVerificationPage extends ConsumerWidget {
  const KycVerificationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScalingFactor(
      child: CustomScaffold(
        appBar: GrowkAppBar(title: 'KYC verification', isBackBtnNeeded: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: const ReusableColumn(
            children: [
              KycVectorImage(),
              KycDescription(),
              ReusableSizedBox(
                height: 50,
              ),
              KycVerificationForm(),
            ],
          ),
        ),
        bottomNavigationBar: const KycVerificationButton(),
      ),
    );
  }
}
