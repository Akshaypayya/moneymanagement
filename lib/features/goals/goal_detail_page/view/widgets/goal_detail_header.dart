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
  final String goalStatus;

  const GoalHeader({
    Key? key,
    required this.goalName,
    this.goalIcon,
    this.goalImageWidget,
    required this.goalStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final textColor = AppColors.current(isDark).text;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: goalStatus == "COMPLETED" ? 80 : 0,
            ),
            Center(
              child: Stack(
                children: [
                  Center(
                    child: Container(
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
                  ),
                ],
              ),
            ),
            goalStatus == "COMPLETED"
                ? Transform.translate(
                    offset: Offset(60, 0),
                    child: Image.asset(
                      AppImages.goalClosedImage,
                      width: 80,
                      height: 80,
                    ),
                  )
                : const SizedBox(),
          ],
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
