import 'package:money_mangmnt/features/bank_details/controller/bank_otp_verification_controller.dart';
import '../../../../views.dart';

Future<void> showOtpBottomSheet(BuildContext context, WidgetRef ref) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 22,
          right: 22,
          top: 20,
        ),
        child: Consumer(
          builder: (context, ref, _) {
            final isLoading = ref.watch(bankOtpControllerProvider).isLoading;

            return IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const OtpInputFieldSection(),
                  const SizedBox(height: 10),
                  GrowkButton(
                    title: 'Verify OTP',
                    onTap: isLoading
                        ? null
                        : () async {
                            final otp = ref.read(otpInputProvider);
                            await ref
                                .read(bankOtpControllerProvider.notifier)
                                .verifyOtp(otp, context, ref);
                          },
                  ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
