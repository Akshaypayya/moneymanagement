import 'package:growk_v2/features/goals/goal_list_page/provider/goal_list_page_provider.dart';
import 'package:growk_v2/views.dart';

Widget goalCheckerErrorState(
    String error, BuildContext context, WidgetRef ref) {
  final isDark = ref.watch(isDarkProvider);
  bool isKycError = error.toLowerCase().contains('kyc');

  return ScalingFactor(
    child: Scaffold(
      backgroundColor: AppColors.current(isDark).scaffoldBackground,
      appBar: GrowkAppBar(
        title: 'Your Savings Goals',
        isBackBtnNeeded: false,
      ),
      body: Container(
        color: isDark ? Colors.black : Colors.white,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(
                    'assets/nogoal.png',
                    height: 250,
                    width: 250,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.receipt_long_outlined,
                        size: 120,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      );
                    },
                  ),
                  ReusableText(
                    text: 'Something went wrong',
                    style:
                        AppTextStyle(textColor: AppColors.current(isDark).text)
                            .titleLrg,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    error,
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
                  if (isKycError)
                    Column(
                      children: [
                        GrowkButton(
                          title: 'Complete KYC',
                          onTap: () {
                            showGrowkSnackBar(
                              context: context,
                              ref: ref,
                              message:
                                  'Please complete KYC verification from your profile',
                              type: SnackType.error,
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        GrowkButton(
                          title: 'Refresh',
                          onTap: () {
                            ref
                                .watch(goalListStateProvider.notifier)
                                .refreshGoals();
                          },
                        )
                      ],
                    )
                  else
                    GrowkButton(
                      title: 'Retry',
                      onTap: () {
                        ref
                            .watch(goalListStateProvider.notifier)
                            .refreshGoals();
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
