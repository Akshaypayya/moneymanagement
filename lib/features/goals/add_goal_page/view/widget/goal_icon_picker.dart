import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/widget/build_icon_image.dart';

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
                child: addGoalBuildIconOrImage(
                    selectedIcon, selectedImage, isDark, ref),
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
}
