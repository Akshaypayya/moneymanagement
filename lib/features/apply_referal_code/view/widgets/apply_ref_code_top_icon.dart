import 'package:growk_v2/views.dart';

class ApplyRefCodeTopIcon extends ConsumerWidget {
  const ApplyRefCodeTopIcon({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return ReusablePadding(
      padding: const EdgeInsets.only(left: 130, right: 130,top: 130,bottom: 80),
      child: Image(
          image: AssetImage(isDark == true
              ? AppImages.appLogoWhite
              : AppImages.appLogoBlack)),
    );
  }
}
