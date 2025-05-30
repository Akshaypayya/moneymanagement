import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/goal_summary_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/controller/standing_instruction_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/view/widgets/goal_detail_item.dart';
import 'package:intl/date_symbols.dart';

class StandingInstructions extends ConsumerWidget {
  final String bankId;
  final String iBanAcntNbr;
  final String goalName;
  final String acntName;
  final String emiAmnt;
  final String duration;
  const StandingInstructions({
    Key? key,
    required this.bankId,
    required this.iBanAcntNbr,
    required this.goalName,
    required this.acntName,
    required this.emiAmnt,
    required this.duration,
  }) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(standingInstructionsControllerProvider);
    final iBanController = ref.read(goalSummaryControllerProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      // color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 20.0),
              child: Text(
                'Set Standing Instruction',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.grey[300] : Colors.grey[700],
                height: 1.5,
              ),
              children: [
                const TextSpan(
                    text: 'Please define a standing instruction of '),
                TextSpan(
                  text: '"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                WidgetSpan(
                  child: Image.asset(
                    AppImages.sarSymbol,
                    height: 13,
                    color: AppColors.current(isDark).primary,
                  ),
                  alignment: PlaceholderAlignment.middle,
                ),
                TextSpan(
                  text: ' $emiAmnt"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' amount in each '),
                TextSpan(
                  text: '"$duration"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(
                    text:
                        ' from your online bank to top up your wallet for the "'),
                TextSpan(
                  text: goalName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: '" gold purchase'),
              ],
            ),
          ),
          GapSpace.height20,
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailItem(
                    isRow: true,
                    label: 'Bank ID',
                    value: bankId,
                    showSymbol: false,
                  ),
                  const SizedBox(height: 8),
                  DetailItem(
                    isRow: true,
                    label: 'IBAN Account Number',
                    value: iBanAcntNbr,
                    showSymbol: false,
                    valOnTap: () =>
                        iBanController.copyVirtualAccountToClipboard(
                            context, iBanAcntNbr, ref),
                  ),
                  const SizedBox(height: 8),
                  DetailItem(
                    isRow: true,
                    label: 'Account Name',
                    value: acntName,
                    showSymbol: false,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.copy,
                      size: 22,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => controller.copyStandingInstructions(
                      context: context,
                      bankId: bankId,
                      iBanAcntNbr: iBanAcntNbr,
                      acntName: acntName,
                      goalName: goalName,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 22,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () => controller.shareStandingInstructions(
                      context: context,
                      bankId: bankId,
                      iBanAcntNbr: iBanAcntNbr,
                      acntName: acntName,
                      goalName: goalName,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
