import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:money_mangmnt/views.dart';

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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: autoDeposit,
            onChanged: (value) {
              ref.read(editAutoDepositProvider.notifier).state = value ?? false;
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
              ref.read(editAutoDepositProvider.notifier).state = !autoDeposit;
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Enable automatic gold deposit when your investment amount reaches SAR 300',
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
