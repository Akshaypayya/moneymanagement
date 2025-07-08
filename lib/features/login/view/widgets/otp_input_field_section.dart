import '../../../../views.dart';

class OtpInputFieldSection extends ConsumerWidget {
  const OtpInputFieldSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final timer = ref.watch(otpTimerProvider);
    final errorText = ref.watch(otpErrorProvider);
    final texts = ref.watch(appTextsProvider);

    return ScalingFactor(
      child: ReusableColumn(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ReusableText(
            text: texts.enterOtpToVerify,
            style: AppTextStyle(textColor: AppColors.current(isDark).text).labelSmall,
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
                style: const TextStyle(
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
                TextSpan(text: "${texts.didntReceiveOtp} "),
                TextSpan(
                  text: texts.resendIn(timer),
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
                  TextSpan(
                    text: "${texts.didntReceiveOtp} ",
                    style: AppTextStyle(textColor: AppColors.current(isDark).text).bodySmall,
                  ),
                  TextSpan(
                    text: texts.resendNow,
                    style: AppTextStyle(textColor: AppColors.current(isDark).resendBlue).titleSmall,
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
