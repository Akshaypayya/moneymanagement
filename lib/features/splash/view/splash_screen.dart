import 'package:money_mangmnt/views.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(splashNavigatorProvider).startTimer(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final logoPath = isDark ? AppImages.appLogoWhite : AppImages.appLogoBlack;

    return ScalingFactor(
      child: CustomScaffold(
        backgroundColor: AppColors.current(isDark).background,
        body: Center(
          child: ReusablePadding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Image(image: AssetImage(logoPath)),
          ),
        ),
      ),
    );
  }
}
