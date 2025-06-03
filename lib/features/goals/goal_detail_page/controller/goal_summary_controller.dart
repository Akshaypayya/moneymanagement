import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/copy_to_clipboard_provider.dart';

import 'package:growk_v2/core/widgets/reusable_snackbar.dart';

final goalSummaryControllerProvider = Provider<GoalSummaryController>((ref) {
  return GoalSummaryController(ref);
});

class GoalSummaryController {
  final Ref ref;

  const GoalSummaryController(this.ref);

  double getProfitValue(String amount, String invested) {
    final double currentAmount = double.tryParse(amount) ?? 0;
    final double investedAmount = double.tryParse(invested) ?? 0;
    final double profitValue = currentAmount - investedAmount;

    debugPrint(
        'GOAL SUMMARY: Profit calculation - Amount: $currentAmount, Invested: $investedAmount, Profit: $profitValue');

    return profitValue;
  }

  Future<void> copyVirtualAccountToClipboard(
      BuildContext context, String virtualAccountNumber, WidgetRef ref) async {
    if (virtualAccountNumber.isEmpty) {
      debugPrint('GOAL SUMMARY: Virtual account number is empty, cannot copy');
      _showErrorSnackbar(
          context, 'Virtual account number is not available', ref);
      return;
    }

    try {
      debugPrint(
          'GOAL SUMMARY: Copying virtual account number: $virtualAccountNumber');

      final clipboardService = ref.read(clipboardProvider);
      await clipboardService.copyToClipboard(virtualAccountNumber);

      // if (context.mounted) {
      //   debugPrint('GOAL SUMMARY: Successfully copied virtual account number');
      //   _showSuccessSnackbar(
      //       context, 'Virtual Account Number copied to clipboard', ref);
      // }
    } catch (e, stackTrace) {
      debugPrint(
          'GOAL SUMMARY ERROR: Failed to copy virtual account number - $e');
      debugPrint('GOAL SUMMARY STACK TRACE: $stackTrace');

      if (context.mounted) {
        _showErrorSnackbar(
            context, 'Failed to copy virtual account number', ref);
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

  bool isProfitPositive(double profitValue) {
    return profitValue > 0;
  }

  bool isProfitNegative(double profitValue) {
    return profitValue < 0;
  }

  String getFormattedProfit(double profitValue) {
    return profitValue.toStringAsFixed(2);
  }
}
