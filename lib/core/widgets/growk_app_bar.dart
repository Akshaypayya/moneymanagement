import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/theme/app_text_styles.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/core/widgets/reusable_text.dart';

class GrowkAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final VoidCallback? onBack;
  final bool isBackBtnNeeded;
  final bool? isActionBtnNeeded;
  final Widget? actionWidget;

  const GrowkAppBar(
      {super.key,
      required this.title,
      this.centerTitle = true,
      this.onBack,
      required this.isBackBtnNeeded,
      this.isActionBtnNeeded,
      this.actionWidget});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final appBarBg = AppColors.current(isDark).background;
    final textColor = AppColors.current(isDark).text;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: appBarBg,
      surfaceTintColor: Colors.transparent,
      centerTitle: centerTitle,
      foregroundColor: textColor,
      leading: isBackBtnNeeded == true
          ? IconButton(
              icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 35),
              onPressed: onBack ?? () => Navigator.of(context).pop(),
            )
          : null,
      title: ReusableText(
        text: title,
        style: AppTextStyle(textColor: textColor).titleRegular,
      ),
      actions: isActionBtnNeeded == true
          ? [
              Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: actionWidget)
            ]
          : [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
