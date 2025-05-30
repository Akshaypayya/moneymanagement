import 'package:growk_v2/views.dart';

class ApplyRefCodeTopText extends ConsumerWidget {
  const ApplyRefCodeTopText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          Center(
            child: Text(
              'Apply Referral code',
              style: AppTextStyle.current(isDark).titleMedium,
            ),
          ),
          ReusableSizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              'If you have a referral code enter it below before proceeding.Share GrowK with your friends and earn gold worth 10 SAR for each successfull referral when they complete their first transaction!',
              style: AppTextStyle.current(isDark).labelSmall,
              textAlign: TextAlign.center,
            ),
          ),
          ReusableSizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
