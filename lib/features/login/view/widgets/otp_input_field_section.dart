import '../../../../views.dart';

class OtpInputFieldSection extends ConsumerWidget {
  const OtpInputFieldSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final timer = ref.watch(otpTimerProvider);
    final errorText = ref.watch(otpErrorProvider);
    return ScalingFactor(
      child: ReusableColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ReusableText(
            text: 'Enter OTP to verify and continue',
            style: AppTextStyle(textColor: AppColors.current(isDark).text)
                .labelSmall,
          ),
          const ReusableSizedBox(height: 30),
          OtpInputField(
            onCompleted: (otp) {
              ref.read(otpInputProvider.notifier).state = otp;
            },
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorText,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
              ),
            ),
          const ReusableSizedBox(height: 20),
          timer > 0
              ? RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle(textColor: AppColors.current(isDark).text).labelSmall,
              children: [
                const TextSpan(text: "Didn’t receive the OTP? "),
                TextSpan(
                  text: "Resend in $timer sec.",
                  style: AppTextStyle(textColor: AppColors.current(isDark).resendBlue).titleSmall,
                ),
              ],
            ),
          )
              : GestureDetector(
            onTap: () async {
              await ref.read(otpControllerProvider).resendLoginOtp(context);
            },
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(text: "Didn’t receive the OTP? ",style: AppTextStyle(
                textColor: AppColors.current(isDark).text,
              ).bodySmall,),
                  TextSpan(
                    text: "Resend now",
                    style: AppTextStyle(
                      textColor: AppColors.current(isDark).resendBlue,
                    ).titleSmall,
                  ),
                ],
              ),
            ),
          ),
          const ReusableSizedBox(height: 30),
        ],
      ),
    );
  }
}
