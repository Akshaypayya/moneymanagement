import '../../views.dart';

class SkipButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final String title;
  const SkipButton({super.key,this.onTap,required this.title});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return ScalingFactor(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: ReusableContainer(
            color: Colors.transparent,
            height: 45,
            width: 250,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Center(
              child: ReusableText(
                text: title,
                style: AppTextStyle(textColor: AppColors.current(isDark).text).titleSmall,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
