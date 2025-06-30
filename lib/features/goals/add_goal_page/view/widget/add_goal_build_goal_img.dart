import 'dart:io';

import 'package:growk_v2/views.dart';

Widget buildGoalImage(String? imagePath, {bool isAsset = false}) {
  final imageWidget = isAsset
      ? Image.asset(
          imagePath!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        )
      : Image.file(
          File(imagePath!),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );

  return ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      width: 80,
      height: 80,
      child: imageWidget,
    ),
  );
}
