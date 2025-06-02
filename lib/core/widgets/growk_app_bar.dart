// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/theme/app_text_styles.dart';
// import 'package:growk_v2/core/theme/app_theme.dart';
// import 'package:growk_v2/core/widgets/reusable_text.dart';

// class GrowkAppBar extends ConsumerWidget implements PreferredSizeWidget {
//   final String title;
//   final bool centerTitle;
//   final VoidCallback? onBack;
//   final bool isBackBtnNeeded;
//   final bool? isActionBtnNeeded;
//   final Widget? actionWidget;

//   const GrowkAppBar(
//       {super.key,
//       required this.title,
//       this.centerTitle = true,
//       this.onBack,
//       required this.isBackBtnNeeded,
//       this.isActionBtnNeeded,
//       this.actionWidget});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isDark = ref.watch(isDarkProvider);
//     final appBarBg = AppColors.current(isDark).background;
//     final textColor = AppColors.current(isDark).text;

//     return AppBar(
//       automaticallyImplyLeading: false,
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       backgroundColor: appBarBg,
//       surfaceTintColor: Colors.transparent,
//       centerTitle: centerTitle,
//       foregroundColor: textColor,
//       leading: isBackBtnNeeded == true
//           ? IconButton(
//               icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 35),
//               onPressed: onBack ?? () => Navigator.of(context).pop(),
//             )
//           : null,
//       title: ReusableText(
//         text: title,
//         style: AppTextStyle(textColor: textColor).titleRegular,
//       ),
//       actions: isActionBtnNeeded == true
//           ? [
//               Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: actionWidget)
//             ]
//           : [],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/theme/app_text_styles.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/widgets/reusable_text.dart';

class GrowkAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final bool centerTitle;
  final VoidCallback? onBack;
  final bool isBackBtnNeeded;
  final bool? isActionBtnNeeded;
  final Widget? actionWidget;
  final bool? showPopupMenu;
  final List<PopupMenuAction>? popupMenuActions;

  const GrowkAppBar({
    super.key,
    required this.title,
    this.centerTitle = true,
    this.onBack,
    required this.isBackBtnNeeded,
    this.isActionBtnNeeded,
    this.actionWidget,
    this.showPopupMenu = false,
    this.popupMenuActions,
  });

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
      actions: _buildActions(context, ref, isDark),
    );
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref, bool isDark) {
    if (showPopupMenu == true &&
        popupMenuActions != null &&
        popupMenuActions!.isNotEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            icon: Icon(
              Icons.more_vert,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () => _showActionBottomSheet(context, ref),
          ),
        ),
      ];
    } else if (isActionBtnNeeded == true && actionWidget != null) {
      return [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: actionWidget!,
        ),
      ];
    }
    return [];
  }

  void _showActionBottomSheet(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GapSpace.height10,
            Text(
              'Goal Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            GapSpace.height20,
            const SizedBox(height: 20),
            ...popupMenuActions!
                .map((action) => _buildActionItem(
                      context,
                      ref,
                      action,
                      isDark,
                    ))
                .toList(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context,
    WidgetRef ref,
    PopupMenuAction action,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
            action.onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  action.icon,
                  size: 24,
                  color: action.iconColor ??
                      (isDark ? Colors.white : Colors.black),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        action.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      if (action.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          action.subtitle!,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class PopupMenuAction {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback onTap;

  const PopupMenuAction({
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    required this.onTap,
  });
}
