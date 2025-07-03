import '../../../views.dart';

class GrowkRefreshIndicator extends ConsumerWidget {
  final Widget child;
  final FutureProvider? providerToRefresh;
  final Future<void> Function(WidgetRef ref)? onRefreshCallback;

  const GrowkRefreshIndicator({
    super.key,
    required this.child,
    this.providerToRefresh,
    this.onRefreshCallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return RefreshIndicator(
      color: isDark?Colors.white:Colors.black,
      backgroundColor: isDark?Colors.grey.shade900:Colors.white,
      displacement: 60,
      strokeWidth: 2.5,
      edgeOffset: 10,
      onRefresh: () async {
        if (onRefreshCallback != null) {
          await onRefreshCallback!(ref);
        } else if (providerToRefresh != null) {
          await ref.refresh(providerToRefresh!.future);
        } else {
          await Future.delayed(const Duration(milliseconds: 500)); // fallback
        }
      },
      child: child,
    );
  }
}
