import 'dart:io';

import 'package:growk_v2/features/goals/add_goal_page/view/widget/add_goal_place_holder.dart';
import 'package:growk_v2/views.dart';

Widget addGoalBuildIconOrImage(
    String selectedIcon, selectedImage, bool isDark) {
  if (selectedImage == null && selectedIcon.isEmpty) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.add_photo_alternate_outlined,
          size: 32,
          color: isDark ? Colors.white : Colors.grey[700],
        ),
        const SizedBox(height: 4),
        Text(
          'Add Icon',
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white : Colors.grey[700],
          ),
        ),
      ],
    );
  }

  if (selectedImage != null) {
    return ClipOval(
      child: Image.file(
        File(selectedImage.path),
        width: 90,
        height: 90,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return buildPlaceholder(isDark);
        },
      ),
    );
  } else if (selectedIcon.isNotEmpty) {
    return Image.asset(
      'assets/$selectedIcon',
      width: 60,
      height: 60,
      errorBuilder: (context, error, stackTrace) {
        return buildPlaceholder(isDark);
      },
    );
  } else {
    return buildPlaceholder(isDark);
  }
}
