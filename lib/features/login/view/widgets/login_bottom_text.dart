import 'package:growk_v2/views.dart';

class LoginBottomText extends ConsumerWidget {
  const LoginBottomText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          ReusableSizedBox(height: 40,),
          Center(
            child: ReusableText(
              text: 'Your personal information is always protected We only use your phone number for secure OTP verification-nothing more!',
              style: AppTextStyle.current(isDark).labelSmall,
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
