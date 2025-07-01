import 'package:growk_v2/views.dart';

class KycDescription extends StatelessWidget {
  final bool isDark;
  const KycDescription({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ReusableText(
      text:
      'To proceed, please enter your Saudi National ID or Iqama Number. We use Nafath Authenticator to securely verify your identity as required by Saudi regulations. Your personal information is encrypted and securely transmitted.',
      style: AppTextStyle(
        textColor: isDark?Colors.white:Colors.black.withOpacity(0.7),
      ).labelSmall, // 12pt, w400, muted color
      maxLines: 4,
      textAlign: TextAlign.justify,
    );
  }
}
