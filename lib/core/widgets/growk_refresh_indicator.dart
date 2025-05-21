import '../../../views.dart';

class GrowkRefreshIndicator extends ConsumerWidget {
  final Widget child;
  final FutureProvider providerToRefresh;

  const GrowkRefreshIndicator({
    super.key,
    required this.child,
    required this.providerToRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return RefreshIndicator(
      color: AppColors.current(isDark).primary,
      backgroundColor: Colors.white,
      displacement: 60,
      strokeWidth: 2.5,
      edgeOffset: 10,
      onRefresh: () async {
        await ref.refresh(providerToRefresh.future);
      },
      child: child,
    );
  }
}
