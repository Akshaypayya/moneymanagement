import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';
import 'package:growk_v2/views.dart';

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
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? Colors.white : Colors.black,
                      width: 1,
                    ),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: goalImageWidget != null
                        ? SizedBox(
                            width: 90,
                            height: 90,
                            child: goalImageWidget!,
                          )
                        : goalIcon != null && goalIcon!.isNotEmpty
                            ? ClipOval(
                                child: Image.asset(
                                  goalIcon!,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.scaleDown,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/customgoals.jpg',
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              )
                            : ClipOval(
                                child: Image.asset(
                                  'assets/customgoals.jpg',
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.contain,
                                ),
                              ),
                  ),
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
