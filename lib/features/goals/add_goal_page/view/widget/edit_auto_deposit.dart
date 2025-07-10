import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/views.dart';

class EditAutoDeposit extends ConsumerStatefulWidget {
  const EditAutoDeposit({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditAutoDepositState();
}

class _EditAutoDepositState extends ConsumerState<EditAutoDeposit> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final autoDeposit = ref.watch(editAutoDepositProvider);
    final texts = ref.watch(appTextsProvider);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: autoDeposit,
            onChanged: (value) {
              final newValue = value ?? false;
              print('EDIT_AUTO_DEPOSIT: Previous value: $autoDeposit');
              print('EDIT_AUTO_DEPOSIT: New value: $newValue');
              print(
                  'EDIT_AUTO_DEPOSIT: Gold Investment will be: ${newValue ? "Y" : "N"}');

              ref.read(editAutoDepositProvider.notifier).state = newValue;

              final updatedState = ref.read(editAutoDepositProvider);
              print('EDIT_AUTO_DEPOSIT: State after update: $updatedState');
              print(
                  'EDIT_AUTO_DEPOSIT: State verification: ${updatedState == newValue ? "SUCCESS" : "FAILED"}');
            },
            activeColor: Colors.teal,
            side: BorderSide(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              final currentValue = ref.read(editAutoDepositProvider);
              final newValue = !currentValue;

              print('=== TAP GESTURE ===');
              print(
                  'EDIT_AUTO_DEPOSIT: Tap detected - Current: $currentValue, New: $newValue');

              ref.read(editAutoDepositProvider.notifier).state = newValue;

              final verificationState = ref.read(editAutoDepositProvider);
              print(
                  'EDIT_AUTO_DEPOSIT: Tap state after update: $verificationState');
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    texts.autodepositAt300,
                    style: TextStyle(
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontSize: 13,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
