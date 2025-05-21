import 'dart:io';

import 'package:money_mangmnt/features/goals/edit_goal_page/controller/edit_goal_controller.dart';
import 'package:money_mangmnt/features/goals/goal_detail_page/model/goal_view_model.dart';
import 'package:money_mangmnt/views.dart';

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
    if (selectedImage != null) {
      return ClipOval(
        child: Image.file(
          File(selectedImage.path),
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return goalData.getIconWidget(width: 60, height: 60);
          },
        ),
      );
    } else if (selectedIcon.isNotEmpty) {
      return Image.asset(
        'assets/$selectedIcon',
        width: 60,
        height: 60,
        errorBuilder: (context, error, stackTrace) {
          return goalData.getIconWidget(width: 60, height: 60);
        },
      );
    } else {
      return goalData.getIconWidget(width: 60, height: 60);
    }
  }
}
