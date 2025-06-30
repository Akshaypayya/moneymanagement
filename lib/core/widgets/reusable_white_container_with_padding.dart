import '../../views.dart';

class ReusableWhiteContainerWithPadding extends ConsumerWidget {
  final Widget widget;
  final bool applyBottomPadding;

  const ReusableWhiteContainerWithPadding({
    super.key,
    required this.widget,
    this.applyBottomPadding = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    final container = ReusableContainer(
      width: double.infinity,
      color: AppColors.current(isDark).background,
      child: ReusablePadding(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
        child: widget,
      ),
    );

    return ScalingFactor(
      child: applyBottomPadding
          ? ReusablePadding(
        padding: const EdgeInsets.only(bottom: 5),
        child: container,
      )
          : container,
    );
  }
}
