import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/views.dart';

Widget transactionEmptyState(bool isDark, BuildContext context, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long_outlined,
                size: 80,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
              ),
              const SizedBox(height: 20),
              Text(
                texts.noTransactionsYet,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                texts.transactionHistoryHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
