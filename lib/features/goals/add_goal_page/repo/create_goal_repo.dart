import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/model/add_goal_model.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/storage/shared_preference/shared_preference_service.dart';

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
        print('CREATE GOAL: Creating minimal JPEG for preset icon');
        String iconName = goalData['iconName'] ?? 'home.png';
        print('CREATE GOAL: Using preset icon: $iconName');

        final imageFile = await _createMinimalJpegFile(iconName);

        response = await network.postMultipartWithJsonField(
          endpoint: AppUrl.createGoalUrl,
          jsonMap:
              goalData.map((key, value) => MapEntry(key, value.toString())),
          file: imageFile,
        );

        await imageFile.delete();
        if (imageFile.parent.existsSync()) {
          try {
            await imageFile.parent.delete();
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

  // Future<File> _createMinimalJpegFile(String iconName) async {
  //   try {
  //     final tempDir = await Directory.systemTemp.createTemp();
  //     final imageFile =
  //         File('${tempDir.path}/${iconName.replaceAll('.png', '.jpg')}');
  Future<File> _createMinimalJpegFile(String iconName) async {
    try {
      final safeIconName = iconName.isEmpty ? "customgoals.png" : iconName;

      final tempDir = await Directory.systemTemp.createTemp();
      final imageFile =
          File('${tempDir.path}/${safeIconName.replaceAll('.png', '.jpg')}');

      final List<int> minimalJpeg = [
        // JPEG header
        0xFF, 0xD8,

        // JFIF APP0 marker
        0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, 0x00, 0x01,
        0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00,

        // Quantization table
        0xFF, 0xDB, 0x00, 0x43, 0x00,
        0x08, 0x06, 0x06, 0x07, 0x06, 0x05, 0x08, 0x07, 0x07, 0x07, 0x09,
        0x09, 0x08, 0x0A, 0x0C, 0x14, 0x0D, 0x0C, 0x0B, 0x0B, 0x0C, 0x19,
        0x12, 0x13, 0x0F, 0x14, 0x1D, 0x1A, 0x1F, 0x1E, 0x1D, 0x1A, 0x1C,
        0x1C, 0x20, 0x24, 0x2E, 0x27, 0x20, 0x22, 0x2C, 0x23, 0x1C, 0x1C,
        0x28, 0x37, 0x29, 0x2C, 0x30, 0x31, 0x34, 0x34, 0x34, 0x1F, 0x27,
        0x39, 0x3D, 0x38, 0x32, 0x3C, 0x2E, 0x33, 0x34, 0x32,

        // Start of Frame
        0xFF, 0xC0, 0x00, 0x11, 0x08, 0x00, 0x01, 0x00, 0x01, 0x01, 0x01,
        0x11, 0x00, 0x02, 0x11, 0x01, 0x03, 0x11, 0x01,

        // Huffman tables
        0xFF, 0xC4, 0x00, 0x14, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x08,
        0xFF, 0xC4, 0x00, 0x14, 0x10, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

        // Start of Scan
        0xFF, 0xDA, 0x00, 0x0C, 0x03, 0x01, 0x00, 0x02, 0x11, 0x03, 0x11,
        0x00, 0x3F, 0x00, 0xB2, 0xC0, 0x07,

        // End of Image
        0xFF, 0xD9
      ];

      await imageFile.writeAsBytes(minimalJpeg);
      print('CREATE GOAL: Created minimal JPEG file: ${imageFile.path}');
      return imageFile;
    } catch (e) {
      print('CREATE GOAL ERROR: Failed to create minimal JPEG: $e');
      rethrow;
    }
  }
}
