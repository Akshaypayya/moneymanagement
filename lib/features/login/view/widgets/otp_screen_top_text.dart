import '../../../../views.dart';

class OtpScreenTopText extends ConsumerWidget {
  const OtpScreenTopText({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final mobileNumber = ref.watch(phoneInputProvider);
    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          Center(
            child: Text(
              'Enter OTP to Proceed',
              style: AppTextStyle.current(isDark).titleMedium,
            ),
          ),
          ReusableSizedBox(height: 20,),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyle.current(isDark).labelSmall,
              children: [
                const TextSpan(
                  text: "A one-time password (OTP) has been sent to \n",
                ),
                TextSpan(
                  text: "+966 $mobileNumber",
                  style: AppTextStyle.current(isDark).titleSmall,
                ),
                const TextSpan(
                  text:
                  ". Please enter the code below to verify your identity and securely access your GrowK account. If you didn't receive the OTP, you can request a new one.",
                ),
              ],
            ),
          ),
          ReusableSizedBox(height: 70,),
        ],
      ),
    );
  }
}
