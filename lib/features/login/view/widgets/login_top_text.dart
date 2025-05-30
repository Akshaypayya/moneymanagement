import 'package:growk_v2/views.dart';

class LoginTopText extends ConsumerWidget {
  const LoginTopText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          Center(
            child: Text(
              'Welcome Back',
              style: AppTextStyle.current(isDark).titleMedium,
            ),
          ),
          ReusableSizedBox(height: 20,),
          Center(
            child: Text(
              'Create your account or sign in security using OTP verification \nEnjoy a seamless and secure experience with Growk!',
              style: AppTextStyle.current(isDark).labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
          ReusableSizedBox(height: 70,),
        ],
      ),
    );
  }
}
