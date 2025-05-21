import 'package:money_mangmnt/views.dart';

class LoginTopIcon extends ConsumerWidget {
  const LoginTopIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return ReusablePadding(
      padding:
          const EdgeInsets.only(left: 100, right: 100, top: 130, bottom: 80),
      child: Image(
          image: AssetImage(isDark == true
              ? AppImages.appLogoWhite
              : AppImages.appLogoBlack)),
    );
  }
}
