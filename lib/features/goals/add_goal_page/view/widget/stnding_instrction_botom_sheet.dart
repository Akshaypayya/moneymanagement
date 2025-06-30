import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/detail_row_stndng_instrn.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/stndg_instrctn_widget.dart';

class StandingInstructionBottomSheet extends ConsumerWidget {
  final String virtualAccount;
  final double transactionAmount;
  final String frequency;
  final String goalName;
  final VoidCallback? onClose;

  const StandingInstructionBottomSheet({
    super.key,
    required this.virtualAccount,
    required this.transactionAmount,
    required this.frequency,
    required this.goalName,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          stndgInstrctnTitle(isDark),
          GapSpace.height20,
          sngInstrctnTextSpan(isDark, transactionAmount, frequency, goalName),
          GapSpace.height20,
          stndgInstrctnContainer(isDark, virtualAccount),
          GapSpace.height20,
          closeStngInstrctn(context, onClose, isDark),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
