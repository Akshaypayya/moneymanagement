import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';

import '../../views.dart';

class GrowkBottomSheetNavigator extends ConsumerWidget {
  final String label;
  final IconData? icon;
  final String valueText;
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final bool disabled;
  final String? errorText;

  /// ⭐️ New: Marks field as mandatory
  final bool isMandatory;

  const GrowkBottomSheetNavigator({
    super.key,
    required this.label,
    this.icon,
    required this.valueText,
    this.onTap,
    this.onClear,
    this.disabled = false,
    this.errorText,
    this.isMandatory = false, // ⭐️ default to false
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final labelColor = disabled ? Colors.grey : isDark?Colors.white:Colors.black54;
    final valueColor = disabled ? Colors.grey[600]! : isDark?Colors.white:Colors.black;
    final hasError = errorText != null && errorText!.isNotEmpty;
    final hasValue = valueText.trim().isNotEmpty;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      behavior: HitTestBehavior.translucent,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) Icon(icon, size: 14, color: labelColor),
                if (icon != null) const SizedBox(width: 6),
                ReusableText(
                  text: label,
                  style: AppTextStyle(textColor: labelColor).labelSmall,
                ),
                if (isMandatory)
                  const Text(
                    ' *',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ReusableText(
                    text: valueText,
                    style: AppTextStyle(textColor: valueColor).titleSmall,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasValue && onClear != null)
                      GestureDetector(
                        onTap: onClear,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 4),
                          child: Icon(Icons.close, size: 18, color: Colors.grey),
                        ),
                      ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: valueColor,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Divider(
              color: hasError ? Colors.red : isDark?Colors.grey.shade800:Colors.grey.shade300,
              thickness: 1,
              height: 1,
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  errorText!,
                  style: AppTextStyle(textColor: Colors.red).labelSmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
