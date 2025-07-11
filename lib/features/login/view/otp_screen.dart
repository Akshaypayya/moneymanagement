import 'package:growk_v2/views.dart';

class OtpScreen extends ConsumerWidget {
  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).background,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22),
          child: Column(
            children: [
              LoginTopIcon(),
              OtpScreenTopText(),
              const OtpInputFieldSection(),
              const SizedBox(height: 100),
              GrowkButton(
                title: 'Verify',
                onTap: () =>
                    ref.read(otpControllerProvider).validateOtp(context, ref),
              ),
              LoginBottomText(),
            ],
          ),
        ),
      ),
    );
  }
}
