import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';

class MonthHeader extends ConsumerWidget {
  final String year;
  final String month;

  const MonthHeader({
    Key? key,
    required this.year,
    required this.month,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          // color: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
          color: AppColors.current(isDark).background,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReusableText(
                text: year,
                style: AppTextStyle(textColor: AppColors.current(isDark).text)
                    .labelSmall,
              ),
              ReusableText(
                text: month,
                style: AppTextStyle(textColor: textColor).titleRegular,
              ),
            ],
          ),
        ),
        Transform.translate(
          offset: Offset(0, -7),
          child: Container(
            color: AppColors.current(isDark).scaffoldBackground,
            height: 5,
          ),
        ),
      ],
    );
  }
}
