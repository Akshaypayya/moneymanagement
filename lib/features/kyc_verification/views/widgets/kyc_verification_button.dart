import 'package:growk_v2/features/kyc_verification/views/widgets/kyc_bottom_text.dart';

import '../../../../views.dart';

class KycVerificationButton extends ConsumerWidget {
  const KycVerificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReusableSizedBox(
      height: 150,
      child: ReusableColumn(
        children: [
          GrowkButton(
            title: 'Verify',
            onTap: () async {
              await ref.read(kycControllerProvider.notifier).submitForm(context,ref);
            },
          ),
          ReusableSizedBox(height: 30,),
          KycBottomText(),
        ],
      ),
    );
  }
}
