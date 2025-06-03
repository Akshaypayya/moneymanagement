import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/growk_button.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/sell_gold_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/provider/sell_gold_provider.dart';

class SellGoldBottomSheet extends ConsumerWidget {
  final String goalName;
  final VoidCallback? onConfirm;

  const SellGoldBottomSheet({
    super.key,
    required this.goalName,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(sellGoldControllerProvider);
    final isLoading = ref.watch(isSellGoldLoadingProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              size: 30,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sell Gold',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Selling the gold in this goal will terminate the goal and credit the equivalent amount to your main wallet.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.grey[300] : Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(children: [
            Expanded(
              child: Expanded(
                child: GrowkButton(
                  title: 'Cancel',
                  onTap: isLoading ? null : () => Navigator.of(context).pop(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GrowkButton(
                title: 'Ok',
                onTap: isLoading
                    ? null
                    : () async {
                        final responseMessage = await controller.sellGold(
                          context: context,
                          goalName: goalName,
                          widgetRef: ref,
                        );
                        if (responseMessage == "No gold balance available." ||
                            responseMessage == "Goal already completed.") {
                          Navigator.of(context).pop(responseMessage);
                          showGrowkSnackBar(
                              context: context,
                              ref: ref,
                              message: responseMessage.toString(),
                              type: responseMessage ==
                                          "No gold balance available." ||
                                      responseMessage ==
                                          "Goal already completed."
                                  ? SnackType.error
                                  : SnackType.success);

                          return;
                        }
                        Navigator.of(context).pop(responseMessage);
                        if (onConfirm != null) {
                          onConfirm!();
                        }
                      },
              ),
            ),
          ]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

void showSellGoldBottomSheet(
  BuildContext context,
  String goalName, {
  VoidCallback? onConfirm,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => SellGoldBottomSheet(
      goalName: goalName,
      onConfirm: onConfirm,
    ),
  );
}
