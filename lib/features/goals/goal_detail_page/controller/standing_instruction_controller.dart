import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/copy_to_clipboard_provider.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';

final standingInstructionsControllerProvider =
    Provider<StandingInstructionsController>((ref) {
  return StandingInstructionsController(ref);
});

class StandingInstructionsController {
  final Ref ref;

  const StandingInstructionsController(this.ref);

  String _formatStandingInstructionsText({
    required String bankId,
    required String iBanAcntNbr,
    required String acntName,
    required String goalName,
  }) {
    return '''
Bank ID : $bankId
IBAN Account Number : $iBanAcntNbr
Account Name : $acntName''';
  }

  Future<void> copyStandingInstructions({
    required BuildContext context,
    required String bankId,
    required String iBanAcntNbr,
    required String acntName,
    required String goalName,
  }) async {
    try {
      debugPrint(
          'STANDING INSTRUCTIONS: Copying standing instructions to clipboard');

      final formattedText = _formatStandingInstructionsText(
        bankId: bankId,
        iBanAcntNbr: iBanAcntNbr,
        acntName: acntName,
        goalName: goalName,
      );

      final clipboardService = ref.read(clipboardProvider);
      await clipboardService.copyToClipboard(formattedText);

      if (context.mounted) {
        debugPrint('STANDING INSTRUCTIONS: Successfully copied to clipboard');
        _showSuccessSnackbar(
            context, 'Standing instructions copied to clipboard');
      }
    } catch (e, stackTrace) {
      debugPrint('STANDING INSTRUCTIONS ERROR: Failed to copy - $e');
      debugPrint('STANDING INSTRUCTIONS STACK TRACE: $stackTrace');

      if (context.mounted) {
        _showErrorSnackbar(context, 'Failed to copy standing instructions');
      }
    }
  }

  Future<void> shareStandingInstructions({
    required BuildContext context,
    required String bankId,
    required String iBanAcntNbr,
    required String acntName,
    required String goalName,
  }) async {
    try {
      debugPrint('STANDING INSTRUCTIONS: Sharing standing instructions');

      final formattedText = _formatStandingInstructionsText(
        bankId: bankId,
        iBanAcntNbr: iBanAcntNbr,
        acntName: acntName,
        goalName: goalName,
      );

      final box = context.findRenderObject() as RenderBox?;
      await Share.share(
        formattedText,
        subject: 'Standing Instruction Details - $goalName',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );

      debugPrint('STANDING INSTRUCTIONS: Successfully initiated share');
    } catch (e, stackTrace) {
      debugPrint('STANDING INSTRUCTIONS ERROR: Failed to share - $e');
      debugPrint('STANDING INSTRUCTIONS STACK TRACE: $stackTrace');

      if (context.mounted) {
        _showErrorSnackbar(context, 'Failed to share standing instructions');
      }
    }
  }

  void _showSuccessSnackbar(
    BuildContext context,
    String message,
  ) {
    showGrowkSnackBar(
      context: context,
      ref: ref as WidgetRef,
      message: message,
      type: SnackType.success,
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    showGrowkSnackBar(
      context: context,
      ref: ref as WidgetRef,
      message: message,
      type: SnackType.error,
    );
  }
}
