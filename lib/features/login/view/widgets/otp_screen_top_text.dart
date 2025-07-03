import '../../../../views.dart';

class OtpScreenTopText extends ConsumerWidget {
  const OtpScreenTopText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final mobileNumber = ref.watch(phoneInputProvider);
    final texts = ref.watch(appTextsProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          Center(
            child: Text(
              texts.enterOtpToProceed,
              style: AppTextStyle.current(isDark).titleMedium,
            ),
          ),
          const ReusableSizedBox(height: 20),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle.current(isDark).labelSmall,
              children: [
                TextSpan(
                  text: "${texts.otpSentMessage}\n",
                ),
                TextSpan(
                  text: "+966 $mobileNumber",
                  style: AppTextStyle.current(isDark).titleSmall,
                ),
                TextSpan(
                  text: " ${texts.otpVerifyInstruction}",
                ),
              ],
            ),
          ),
          const ReusableSizedBox(height: 70),
        ],
      ),
    );
  }
}
