import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/views.dart';

Widget transactionLoadingState(bool isDark) {
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
          'Loading your transactions...',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        ),
      ],
    ),
  );
}
