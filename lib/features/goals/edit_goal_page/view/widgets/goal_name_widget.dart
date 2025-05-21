import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/views.dart';

class GoalNameWidget extends ConsumerStatefulWidget {
  final String goalName;
  const GoalNameWidget({required this.goalName, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GoalNameWidgetState();
}

class _GoalNameWidgetState extends ConsumerState<GoalNameWidget> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    return Center(
      child: Text(widget.goalName,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          )),
    );
  }
}
