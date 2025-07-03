import 'package:growk_v2/views.dart';

class LoginBottomText extends ConsumerWidget {
  const LoginBottomText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          ReusableSizedBox(height: 40,),
          Center(
            child: ReusableText(
              text: texts.loginBottomDescription,
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
