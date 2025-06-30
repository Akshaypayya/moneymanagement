import 'package:growk_v2/views.dart';

Widget goalCheckerLoadingState(WidgetRef ref) {
  final isDark = ref.watch(isDarkProvider);
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                    color: isDark ? Colors.white : Colors.black),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
