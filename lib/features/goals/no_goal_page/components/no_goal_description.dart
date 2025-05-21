import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_space.dart';
import 'package:money_mangmnt/views.dart';

Widget noGoalDescription({required WidgetRef ref}) {
  final isDark = ref.watch(isDarkProvider);
  final textColor = AppColors.current(isDark).text;
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
    child: Column(
      children: [
        ReusableText(
          text: 'No Goals Yet',
          style: AppTextStyle(textColor: textColor).titleLrg,
        ),
        GapSpace.height20,
        Text(
          'Start your journey toward smarter gold savings. Create a goal and invest automatically over time.',
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
      ],
    ),
  );
}
