// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:growk_v2/core/constants/app_space.dart';
// import 'package:growk_v2/core/theme/app_theme.dart';
// import 'package:growk_v2/features/goals/add_goal_page/controller/create_goal_controller.dart';
// import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';

// class StandingInstructionBottomSheet extends ConsumerWidget {
//   const StandingInstructionBottomSheet({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = ref.watch(isDarkProvider);
//     final controller = ref.read(createGoalControllerProvider);

//     final goalName = ref.watch(goalNameProvider);
//     final selectedFrequency = ref.watch(frequencyProvider);
//     final targetYear = ref.watch(calculatedYearProvider);
//     final targetAmount = ref.watch(calculatedAmountProvider).round();

//     final durationInYears = (targetYear - 2025);
//     final duration = durationInYears > 3 ? 3 : durationInYears;
//     final actualDurationInMonths = duration * 12;

//     double transactionAmount;
//     String frequencyText;

//     switch (selectedFrequency) {
//       case 'Daily':
//         transactionAmount = targetAmount / (actualDurationInMonths * 30);
//         frequencyText = 'Daily';
//         break;
//       case 'Weekly':
//         transactionAmount = targetAmount / (actualDurationInMonths * 4);
//         frequencyText = 'Weekly';
//         break;
//       case 'Monthly':
//       default:
//         transactionAmount = targetAmount / actualDurationInMonths;
//         frequencyText = 'Monthly';
//         break;
//     }

//     return Container(
//       decoration: BoxDecoration(
//         color: isDark ? Colors.grey[900] : Colors.white,
//         borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       padding: const EdgeInsets.all(24),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.only(bottom: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[400],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//           ),
//           Center(
//             child: Text(
//               'Set Standing Instruction',
//               style: TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: GoogleFonts.poppins().fontFamily,
//                 color: isDark ? Colors.white : Colors.black,
//               ),
//             ),
//           ),
//           GapSpace.height20,
//           Text(
//             'Please define a standing instruction of SAR ${transactionAmount.toStringAsFixed(2)} amount in each $frequencyText from your online bank to top up your wallet for the "$goalName" gold purchase',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               color: isDark ? Colors.grey[300] : Colors.grey[700],
//               height: 1.5,
//             ),
//           ),
//           GapSpace.height30,
//           Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               color:
//                   isDark ? Colors.grey[800]?.withOpacity(0.3) : Colors.grey[50],
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
//                 width: 1,
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildDetailRow('Bank ID', 'Arab National Bank', isDark),
//                 const SizedBox(height: 12),
//                 _buildDetailRow(
//                     'IBAN Account Number', 'SA1234567890123456789', isDark),
//                 const SizedBox(height: 12),
//                 _buildDetailRow('Account Name', 'Nexus Global Limited', isDark),
//               ],
//             ),
//           ),
//           GapSpace.height30,
//           SizedBox(
//             width: double.infinity,
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 controller.createGoal(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: isDark ? Colors.white : Colors.black,
//                 foregroundColor: isDark ? Colors.black : Colors.white,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 elevation: 0,
//               ),
//               child: Text(
//                 'Close',
//                 style: TextStyle(
//                   fontFamily: GoogleFonts.poppins().fontFamily,
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//         ],
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value, bool isDark) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           flex: 2,
//           child: Text(
//             '$label:',
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               color: isDark ? Colors.grey[400] : Colors.grey[600],
//             ),
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           flex: 3,
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               fontFamily: GoogleFonts.poppins().fontFamily,
//               color: isDark ? Colors.white : Colors.black,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
