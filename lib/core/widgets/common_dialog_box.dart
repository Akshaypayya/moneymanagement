import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // For WidgetRef
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/views.dart';

class CommonDialog extends ConsumerWidget {
  final String title;
  final String content;
  final String positiveButtonText;
  final String? negativeButtonText;
  final String? number;
  final VoidCallback? onPositivePressed;
  final VoidCallback? onNegativePressed;

  const CommonDialog({
    super.key,
    required this.title,
    required this.content,
    required this.positiveButtonText,
    this.negativeButtonText,
    this.onPositivePressed,
    this.onNegativePressed,
    this.number,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final colors = AppColors.current(isDark);

    return Dialog(
      backgroundColor: colors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReusableSizedBox(
              height: 50,
              width: 50,
              child: Image(image: AssetImage(AppImages.nafathLogo)),
            ),
            ReusableText(
              text: title,
              style: AppTextStyle(textColor: colors.text).titleSmall,
            ),
            const SizedBox(height: 12),
            ReusableText(
              maxLines: 10,
              text: content,
              textAlign: TextAlign.justify,
              style: AppTextStyle(textColor: colors.text).bodyKycSmall,
            ),
            const SizedBox(height: 15),
            ReusableText(
              maxLines: 1,
              text: number??'',
              textAlign: TextAlign.justify,
              style: AppTextStyle(textColor: colors.text).headlineVeryLarge,
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
