import 'package:growk_v2/views.dart';

class LoginTopText extends ConsumerWidget {
  const LoginTopText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          Center(
            child: Text(
              texts.welcomeBack,
              style: AppTextStyle.current(isDark).titleMedium,
            ),
          ),
          ReusableSizedBox(height: 20,),
          Center(
            child: Text(
              texts.loginTopDescription,
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
