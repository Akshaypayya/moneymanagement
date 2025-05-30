import '../../views.dart';

final isButtonLoadingProvider = StateProvider<bool>((ref) => false);

class GrowkButton extends ConsumerWidget {
  final VoidCallback? onTap;
  final String title;

  const GrowkButton({
    super.key,
    this.onTap,
    required this.title,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isLoading = ref.watch(isButtonLoadingProvider);

    return ScalingFactor(
      child: GestureDetector(
        onTap: isLoading ? null : onTap,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: 45,
            width: 250,
            decoration: BoxDecoration(
              color: isLoading
                  ? AppColors.current(isDark).primary.withOpacity(0.5)
                  : AppColors.current(isDark).primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : ReusableText(
                      text: title,
                      style: AppTextStyle(
                        textColor: AppColors.current(isDark).background,
                      ).titleSmall,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
