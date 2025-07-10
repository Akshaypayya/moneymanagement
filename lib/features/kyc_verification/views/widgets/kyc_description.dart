import 'package:growk_v2/views.dart';

class KycDescription extends ConsumerWidget {
  final bool isDark;
  const KycDescription({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final texts = ref.watch(appTextsProvider);

    return ReusableText(
      text: texts.kycDescription,
      style: AppTextStyle(
        textColor: isDark ? Colors.white : Colors.black.withOpacity(0.7),
      ).labelSmall,
      maxLines: 4,
      textAlign: TextAlign.justify,
    );
  }
}
