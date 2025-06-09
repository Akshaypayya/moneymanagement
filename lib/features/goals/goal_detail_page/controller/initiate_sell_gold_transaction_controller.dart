import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/initiate_gold_sell_transaction_model.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/inititate_sell_gold_transacation_provider.dart';

final initiateSellGoldControllerProvider =
    Provider<InitiateSellGoldController>((ref) {
  return InitiateSellGoldController(ref);
});

class InitiateSellGoldController {
  final Ref ref;

  const InitiateSellGoldController(this.ref);

  Future<InitiateSellGoldData?> initiateSellGold({
    required BuildContext context,
    required String goalName,
    required WidgetRef widgetRef,
  }) async {
    debugPrint(
        'INITIATE SELL GOLD CONTROLLER: Starting initiate sell gold operation');
    debugPrint('INITIATE SELL GOLD CONTROLLER: Goal name: $goalName');

    if (goalName.isEmpty) {
      debugPrint('INITIATE SELL GOLD CONTROLLER ERROR: Goal name is empty');
      _showErrorSnackbar(
          context, 'Goal information is not available', widgetRef);
      return null;
    }

    try {
      ref.read(isInitiateSellGoldLoadingProvider.notifier).state = true;

      final repository = ref.read(initiateSellGoldRepositoryProvider);
      final result = await repository.initiateSellGold(goalName: goalName);

      ref.read(isInitiateSellGoldLoadingProvider.notifier).state = false;

      if (result.isSuccess && result.data != null) {
        debugPrint(
            'INITIATE SELL GOLD CONTROLLER: Successfully initiated sell gold');

        ref.read(initiateSellGoldDataProvider.notifier).state = result.data;

        return result.data;
      } else {
        debugPrint(
            'INITIATE SELL GOLD CONTROLLER ERROR: Initiate sell gold failed - ${result.message}');

        if (context.mounted) {
          _showErrorSnackbar(context,
              result.message ?? 'Failed to initiate sell gold', widgetRef);
        }
        return null;
      }
    } catch (e, stackTrace) {
      debugPrint(
          'INITIATE SELL GOLD CONTROLLER ERROR: Failed to initiate sell gold - $e');
      debugPrint('INITIATE SELL GOLD CONTROLLER STACK TRACE: $stackTrace');

      ref.read(isInitiateSellGoldLoadingProvider.notifier).state = false;

      if (context.mounted) {
        _showErrorSnackbar(context,
            'Failed to initiate sell gold. Please try again.', widgetRef);
      }
      return null;
    }
  }

  double calculateTotalReceivableAmount({
    required double goldQuantity,
    required double goldSellPrice,
    required double convenienceFee,
  }) {
    final goldAmount = goldQuantity * goldSellPrice;
    final totalReceivable = goldAmount - convenienceFee;
    return totalReceivable > 0 ? totalReceivable : 0;
  }

  double calculateGoldAmount({
    required double goldQuantity,
    required double goldSellPrice,
  }) {
    return goldQuantity * goldSellPrice;
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
