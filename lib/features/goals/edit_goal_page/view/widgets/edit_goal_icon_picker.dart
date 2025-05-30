import 'dart:io';

import 'package:growk_v2/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:growk_v2/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:growk_v2/views.dart';

class EditGoalIconPicker extends ConsumerStatefulWidget {
  final GoalData? goalData;
  const EditGoalIconPicker({this.goalData, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditGoalIconPickerState();
}

class _EditGoalIconPickerState extends ConsumerState<EditGoalIconPicker> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final controller = ref.read(editGoalControllerProvider);
    final selectedIcon = ref.watch(editSelectedGoalIconProvider);
    final selectedImage = ref.watch(editSelectedImageFileProvider);

    print('ICON PICKER: Selected icon: $selectedIcon');
    print('ICON PICKER: Has custom image: ${selectedImage != null}');

    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? Colors.white : Colors.black,
                width: 1,
              ),
            ),
            child: GestureDetector(
              onTap: () => controller.pickGoalImageActionSheet(context, ref),
              child: Center(
                child: _buildIconOrImage(
                    selectedIcon, selectedImage, widget.goalData!),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
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
        ],
      ),
    );
  }

  Widget _buildIconOrImage(
      String selectedIcon, XFile? selectedImage, GoalData goalData) {
    print('BUILD ICON: selectedIcon = "$selectedIcon"');
    print('BUILD ICON: selectedImage = ${selectedImage?.path}');

    if (selectedImage != null) {
      print('BUILD ICON: Using custom uploaded image');
      return ClipOval(
        child: Image.file(
          File(selectedImage.path),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print(
                'BUILD ICON ERROR: Failed to load custom image, falling back to goal data widget');
            return goalData.getIconWidget(width: 60, height: 60);
          },
        ),
      );
    }

    if (selectedIcon.isNotEmpty) {
      print('BUILD ICON: Using selected preset icon: assets/$selectedIcon');
      return ClipOval(
        child: Image.asset(
          'assets/$selectedIcon',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print(
                'BUILD ICON ERROR: Failed to load asset $selectedIcon, falling back to goal data widget');
            return goalData.getIconWidget(width: 60, height: 60);
          },
        ),
      );
    }

    print('BUILD ICON: Using goal data widget as fallback');
    return goalData.getIconWidget(width: 60, height: 60);
  }
}
