import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/views.dart';

Widget transactionLoadingState(bool isDark, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          texts.loadingYourTransactions,
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ],
    ),
  );
}
