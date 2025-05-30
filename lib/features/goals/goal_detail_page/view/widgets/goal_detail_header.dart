import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';

class GoalHeader extends ConsumerWidget {
  final String goalName;
  final String? goalIcon;
  final Widget? goalImageWidget;

  const GoalHeader({
    Key? key,
    required this.goalName,
    this.goalIcon,
    this.goalImageWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.white : Colors.black,
                    width: 1,
                  ),
                ),
                child:
                    // Image(
                    //   image: NetworkImage(goalIcon ?? ''),
                    //   width: 80,
                    //   height: 80,
                    //   fit: BoxFit.cover,
                    // ),
                    Padding(
                  padding: const EdgeInsets.all(12),
                  child: goalImageWidget ??
                      (goalIcon != null && goalIcon!.isNotEmpty
                          ? Image.asset(
                              goalIcon!,
                              width: 80,
                              height: 80,
                            )
                          : Image.asset(
                              'assets/customgoals.png',
                              width: 80,
                              height: 80,
                            )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
          child: ReusableText(
            text: goalName,
            style: AppTextStyle(textColor: textColor).titleMedium,
          ),
        ),
      ],
    );
  }
}
