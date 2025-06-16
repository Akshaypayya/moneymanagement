import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/goals/add_goal_page/controller/create_goal_controller.dart';
import 'package:growk_v2/features/goals/add_goal_page/model/add_goal_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/goals/edit_goal_page/model/edit_goal_model.dart';
import 'package:growk_v2/core/network/network_service.dart';

class EditGoalRepository {
  final NetworkService network;
  final Ref ref;

  EditGoalRepository(this.network, this.ref);

  Future<CreateGoalModel> updateGoalApi(
    String accessToken,
    XFile? imageFile,
    File formDataFile,
  ) async {
    print('EDIT GOAL: Starting API call with NetworkService');
    print('EDIT GOAL: Image file provided: ${imageFile != null}');

    try {
      final jsonString = await formDataFile.readAsString();
      final goalData = jsonDecode(jsonString) as Map<String, dynamic>;
      print('EDIT GOAL: Goal data: $goalData');
      print('EDIT GOAL: URL: ${AppUrl.baseUrl}${AppUrl.updateGoalUrl}');

      Map<String, dynamic> response;

      if (imageFile != null) {
        print('EDIT GOAL: Using putMultipartWithJsonField with custom image');
        File imageFileForUpload = File(imageFile.path);

        if (!await imageFileForUpload.exists()) {
          throw Exception(
              'Image file does not exist at path: ${imageFile.path}');
        }

        try {
          final fileSize = await imageFileForUpload.length();
          print('EDIT GOAL: Image file size: $fileSize bytes');
        } catch (e) {
          throw Exception('Cannot read image file: $e');
        }

        response = await network.putMultipartWithJsonField(
          endpoint: AppUrl.updateGoalUrl,
          jsonMap:
              goalData.map((key, value) => MapEntry(key, value.toString())),
          file: imageFileForUpload,
        );
      } else {
        print('EDIT GOAL: Using preset icon or default');
        String iconToUse = 'customgoals.jpg';
        if (goalData.containsKey('iconName') && goalData['iconName'] != null) {
          iconToUse = goalData['iconName'] as String;
          print('EDIT GOAL: Using preset icon: $iconToUse');
        } else {
          print('EDIT GOAL: No icon specified, using default: $iconToUse');
        }

        final assetImageFile =
            await CreateGoalController(ref).assetImageToFile(iconToUse);

        response = await network.putMultipartWithJsonField(
          endpoint: AppUrl.updateGoalUrl,
          jsonMap:
              goalData.map((key, value) => MapEntry(key, value.toString())),
          file: assetImageFile,
        );

        await assetImageFile.delete();
        if (assetImageFile.parent.existsSync()) {
          try {
            await assetImageFile.parent.delete();
          } catch (e) {
            print('EDIT GOAL: Could not delete temp directory: $e');
          }
        }
      }

      print('EDIT GOAL: Response received: $response');
      return CreateGoalModel.fromJson(response);
    } catch (e, stackTrace) {
      print('EDIT GOAL EXCEPTION: $e');
      print('EDIT GOAL STACK TRACE: $stackTrace');

      return CreateGoalModel(
        status: 'failed',
        message: 'Error: $e',
      );
    }
  }
}
