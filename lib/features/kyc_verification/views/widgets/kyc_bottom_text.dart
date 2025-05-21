import '../../../../views.dart';
class KycBottomText extends StatelessWidget {
  const KycBottomText({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusablePadding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: ReusableText(
        text:
        'We do not store your ID details. Your data is used solely for verification purposes in compliance with Saudi data protection laws.',
        style: AppTextStyle(
          textColor: Colors.black.withOpacity(0.7), // softer black
        ).labelSmall, // 12pt, w400, subtle color
        maxLines: 4,
        textAlign: TextAlign.justify,
      ),
    );
  }
}
