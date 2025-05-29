import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/view/widgets/goal_detail_item.dart';
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
          Text(
            'Please define a standing instruction of $emiAmnt amount in each $duration from your online bank to top up your wallet for the $goalName gold purchase',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
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
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share,
                      size: 22,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                    onPressed: () {},
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
