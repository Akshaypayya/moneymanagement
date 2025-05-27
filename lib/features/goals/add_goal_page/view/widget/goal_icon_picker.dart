import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/provider/add_goal_provider.dart';

class GoalIconPicker extends ConsumerWidget {
  const GoalIconPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(createGoalControllerProvider);
    final selectedIcon = ref.watch(selectedGoalIconProvider);
    final selectedImage = ref.watch(selectedImageFileProvider);

    return Center(
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => controller.pickGoalImageActionSheet(context, ref),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white : Colors.black,
                  width: 1,
                ),
                color: isDark ? Colors.grey[800] : Colors.grey[100],
              ),
              child: Center(
                child: _buildIconOrImage(selectedIcon, selectedImage, isDark),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => controller.pickGoalImageActionSheet(context, ref),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? Colors.black : Colors.white,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconOrImage(String selectedIcon, selectedImage, bool isDark) {
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
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholder(isDark);
          },
        ),
      );
    } else if (selectedIcon.isNotEmpty) {
      return Image.asset(
        'assets/$selectedIcon',
        width: 60,
        height: 60,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder(isDark);
        },
      );
    } else {
      return _buildPlaceholder(isDark);
    }
  }

  Widget _buildPlaceholder(bool isDark) {
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
}
