import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/views.dart';

Widget buildTransactionErrorState(
    String errorMessage, bool isDark, BuildContext context, WidgetRef ref) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/nogoal.png',
                height: 200,
                width: 200,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error_outline,
                    size: 80,
                    color: isDark ? Colors.red[300] : Colors.red,
                  );
                },
              ),
              const SizedBox(height: 20),
              ReusableText(
                text: 'Something went wrong',
                style: AppTextStyle(textColor: AppColors.current(isDark).text)
                    .titleLrg,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 16),
              GrowkButton(
                title: 'Retry',
                onTap: () {
                  debugPrint("TRANSACTIONS PAGE: Retry button pressed");
                  ref
                      .read(paginatedTransactionProvider.notifier)
                      .refreshTransactions();
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
