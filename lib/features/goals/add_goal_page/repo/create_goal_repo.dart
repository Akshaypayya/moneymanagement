import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/goals/add_goal_page/controller/create_goal_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/goals/add_goal_page/model/add_goal_model.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';

class CreateGoalRepository {
  final NetworkService network;
  final Ref ref;

  CreateGoalRepository(this.network, this.ref);

  Future<CreateGoalModel> addGoalApi(
    String accessToken,
    XFile? imageFile,
    File formDataFile,
  ) async {
    print('CREATE GOAL: Starting API call with NetworkService');
    print('CREATE GOAL: Image file provided: ${imageFile != null}');

    try {
      final jsonString = await formDataFile.readAsString();
      final goalData = jsonDecode(jsonString) as Map<String, dynamic>;
      print('CREATE GOAL: Goal data: $goalData');
      print('CREATE GOAL: URL: ${AppUrl.baseUrl}${AppUrl.createGoalUrl}');

      Map<String, dynamic> response;

      if (imageFile != null) {
        print(
            'CREATE GOAL: Using postMultipartWithJsonField with custom image');
        File imageFileForUpload = File(imageFile.path);
        response = await network.postMultipartWithJsonField(
          endpoint: AppUrl.createGoalUrl,
          jsonMap:
              goalData.map((key, value) => MapEntry(key, value.toString())),
          file: imageFileForUpload,
        );
      } else {
        print('CREATE GOAL: Using preset icon or default');
        String iconToUse = 'customgoals.jpg';
        if (goalData.containsKey('iconName') && goalData['iconName'] != null) {
          iconToUse = goalData['iconName'] as String;
          print('CREATE GOAL: Using preset icon: $iconToUse');
        } else {
          print('CREATE GOAL: No icon specified, using default: $iconToUse');
        }

        final assetImageFile =
            await CreateGoalController(ref).assetImageToFile(iconToUse);

        response = await network.postMultipartWithJsonField(
          endpoint: AppUrl.createGoalUrl,
          jsonMap:
              goalData.map((key, value) => MapEntry(key, value.toString())),
          file: assetImageFile,
        );

        await assetImageFile.delete();
        if (assetImageFile.parent.existsSync()) {
          try {
            await assetImageFile.parent.delete();
          } catch (e) {
            print('CREATE GOAL: Could not delete temp directory: $e');
          }
        }
      }

      print('CREATE GOAL: Response received: $response');
      return CreateGoalModel.fromJson(response);
    } catch (e, stackTrace) {
      print('CREATE GOAL EXCEPTION: $e');
      print('CREATE GOAL STACK TRACE: $stackTrace');

      return CreateGoalModel(
        status: 'failed',
        message: 'Error: $e',
      );
    }
  }
}
