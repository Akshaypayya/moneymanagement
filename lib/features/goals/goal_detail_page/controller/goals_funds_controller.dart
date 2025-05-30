import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/transfer_amount_provider.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_load_amnt_botm_sheet.dart';

final loadFundsControllerProvider = Provider<LoadFundsController>((ref) {
  return LoadFundsController(ref);
});

final loadAmountProvider = StateProvider<String>((ref) => '');
final isLoadingFundsProvider = StateProvider<bool>((ref) => false);

class LoadFundsController {
  final Ref ref;

  const LoadFundsController(this.ref);

  void showLoadFundsBottomSheet(BuildContext context) {
    debugPrint('LOAD FUNDS: Showing load funds bottom sheet');

    ref.read(loadAmountProvider.notifier).state = '';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const LoadFundsBottomSheet(),
    );
  }

  String? validateAmount(String amount) {
    if (amount.isEmpty) {
      return 'Please enter an amount';
    }

    final double? parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) {
      return 'Please enter a valid amount';
    }

    if (parsedAmount <= 0) {
      return 'Amount must be greater than 0';
    }

    if (parsedAmount > 1000000) {
      return 'Amount cannot exceed SAR 1,000,000';
    }

    return null;
  }

  Future<void> loadFunds(BuildContext context, String goalName, WidgetRef ref,
      {VoidCallback? onSuccess}) async {
    final amount = ref.read(loadAmountProvider);

    debugPrint('LOAD FUNDS: Starting load funds operation');
    debugPrint('LOAD FUNDS: Goal name: $goalName');
    debugPrint('LOAD FUNDS: Amount: $amount');

    final validationError = validateAmount(amount);
    if (validationError != null) {
      debugPrint('LOAD FUNDS ERROR: Validation failed - $validationError');
      _showErrorSnackbar(context, validationError, ref);
      return;
    }

    if (goalName.isEmpty) {
      debugPrint('LOAD FUNDS ERROR: Goal name is empty');
      _showErrorSnackbar(context, 'Goal information is not available', ref);
      return;
    }

    try {
      ref.read(isLoadingFundsProvider.notifier).state = true;

      final repository = ref.read(transferAmountRepositoryProvider);
      final result = await repository.transferAmount(
        goalName: goalName,
        amount: double.parse(amount),
      );

      ref.read(isLoadingFundsProvider.notifier).state = false;

      if (result.isSuccess) {
        debugPrint('LOAD FUNDS: Successfully transferred funds');

        if (context.mounted) {
          Navigator.of(context).pop();

          _showSuccessSnackbar(context, result.message, ref);

          ref.read(loadAmountProvider.notifier).state = '';

          if (onSuccess != null) {
            onSuccess();
          }
        }
      } else {
        debugPrint('LOAD FUNDS ERROR: Transfer failed - ${result.message}');

        if (context.mounted) {
          _showErrorSnackbar(context, result.message, ref);
        }
      }
    } catch (e, stackTrace) {
      debugPrint('LOAD FUNDS ERROR: Failed to load funds - $e');
      debugPrint('LOAD FUNDS STACK TRACE: $stackTrace');

      ref.read(isLoadingFundsProvider.notifier).state = false;

      if (context.mounted) {
        _showErrorSnackbar(
            context, 'Failed to load funds. Please try again.', ref);
      }
    }
  }

  void updateLoadAmount(String amount) {
    ref.read(loadAmountProvider.notifier).state = amount;
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

  String formatAmount(String amount) {
    final double? parsedAmount = double.tryParse(amount);
    if (parsedAmount == null) return amount;
    return parsedAmount.toStringAsFixed(2);
  }
}
