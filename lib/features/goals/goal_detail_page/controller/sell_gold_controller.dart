import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/sell_gold_provider.dart';

final sellGoldControllerProvider = Provider<SellGoldController>((ref) {
  return SellGoldController(ref);
});

class SellGoldController {
  final Ref ref;

  const SellGoldController(this.ref);

  Future sellGold({
    required BuildContext context,
    required String goalName,
    required WidgetRef widgetRef,
    VoidCallback? onSuccess,
  }) async {
    debugPrint('SELL GOLD CONTROLLER: Starting sell gold operation');
    debugPrint('SELL GOLD CONTROLLER: Goal name: $goalName');

    if (goalName.isEmpty) {
      debugPrint('SELL GOLD CONTROLLER ERROR: Goal name is empty');
      _showErrorSnackbar(
          context, 'Goal information is not available', widgetRef);
      return;
    }

    try {
      ref.read(isSellGoldLoadingProvider.notifier).state = true;

      final repository = ref.read(sellGoldRepositoryProvider);
      final result = await repository.sellGold(goalName: goalName);

      ref.read(isSellGoldLoadingProvider.notifier).state = false;

      if (result.isSuccess) {
        debugPrint('SELL GOLD CONTROLLER: Successfully sold gold');

        if (context.mounted) {
          _showSuccessSnackbar(context, result.message, widgetRef);

          if (onSuccess != null) {
            onSuccess();
          }
        }
      } else {
        debugPrint(
            'SELL GOLD CONTROLLER ERROR: Sell gold failed - ${result.message}');

        if (context.mounted) {
          _showErrorSnackbar(context, result.message, widgetRef);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('SELL GOLD CONTROLLER ERROR: Failed to sell gold - $e');
      debugPrint('SELL GOLD CONTROLLER STACK TRACE: $stackTrace');

      ref.read(isSellGoldLoadingProvider.notifier).state = false;

      if (context.mounted) {
        _showErrorSnackbar(
            context, 'Failed to sell gold. Please try again.', widgetRef);
      }
    }
  }

  void _showSuccessSnackbar(
      BuildContext context, String message, WidgetRef ref) {
    showGrowkSnackBar(
      context: context,
      ref: ref,
      message: message,
      type: SnackType.success,
    );
  }

  void _showErrorSnackbar(BuildContext context, String message, WidgetRef ref) {
    showGrowkSnackBar(
      context: context,
      ref: ref,
      message: message,
      type: SnackType.error,
    );
  }
}
