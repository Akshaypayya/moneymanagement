import 'package:growk_v2/views.dart';

class ApplyRefCodeTopText extends ConsumerWidget {
  const ApplyRefCodeTopText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);

    return ReusableSizedBox(
      child: ReusableColumn(
        children: <Widget>[
          Center(
            child: Text(
              texts.applyReferralCodeTitle,
              style: AppTextStyle.current(isDark).titleMedium,
            ),
          ),
          ReusableSizedBox(
            height: 20,
          ),
          Center(
            child: Text(
            texts.applyReferralCodeDescription,
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
