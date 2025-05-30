import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/profile_page/model/update_prof_pic_model.dart';
import 'package:growk_v2/core/utils/app_permission.dart';
import 'package:http/http.dart' as http;
import 'package:growk_v2/core/storage/shared_preference/shared_preference_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

class ProfilePictureRepository {
  final String baseUrl;

  ProfilePictureRepository({required this.baseUrl});

  Future<ProfilePictureModel> uploadProfilePicture(File imageFile) async {
    Future<http.Response> sendRequest(String token) async {
      final url = Uri.parse(AppUrl.baseUrl + AppUrl.uploadProPicUrl);
      final request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      final file = await http.MultipartFile.fromPath(
        'imageFile',
        imageFile.path,
        filename: path.basename(imageFile.path),
      );
      request.files.add(file);
      final streamedResponse = await request.send();
      return http.Response.fromStream(streamedResponse);
    }
    try {
      String? token = SharedPreferencesHelper.getString("access_token");
      if (token == null) {
        return ProfilePictureModel(
            status: 'failed', message: 'No token available');
      }
      http.Response response = await sendRequest(token);
      if (response.statusCode == 401) {
        bool refreshed = await _refreshToken();
        if (refreshed) {
          token = SharedPreferencesHelper.getString("access_token");
          if (token != null) {
            response = await sendRequest(token);
          }
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        return ProfilePictureModel.fromJson(responseData);
      } else {
        return ProfilePictureModel(
          status: 'failed',
          message: 'Failed: HTTP ${response.statusCode}',
        );
      }
    } catch (e) {
      return ProfilePictureModel(status: 'failed', message: 'Error: $e');
    }
  }

  Future<File?> pickProfileImage(BuildContext context) async {
    try {
      bool hasPermission = false;
      if (Platform.isAndroid) {
        final isAndroid13 = await _isAndroid13OrHigher();
        if (isAndroid13) {
          hasPermission = await Permission.photos.request().isGranted;
        } else {
          hasPermission = await Permission.storage.request().isGranted;
        }
      } else {
        hasPermission = await Permission.photos.request().isGranted;
      }

      if (!hasPermission) return null;

      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (image == null) return null;

      return _processImage(File(image.path));
    } catch (e) {
      debugPrint('Pick Image Error: $e');
      return null;
    }
  }

  Future<File?> captureProfileImage(BuildContext context) async {
    try {
      final granted = await PermissionService.requestCameraPermission(context);
      if (!granted) return null;

      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 800,
        maxHeight: 800,
        preferredCameraDevice: CameraDevice.front,
      );

      if (image == null) return null;

      return _processImage(File(image.path));
    } catch (e) {
      debugPrint('Capture Image Error: $e');
      return null;
    }
  }

  Future<File> _processImage(File imageFile) async {
    final extension = path.extension(imageFile.path).toLowerCase();
    if (extension == '.jpg' || extension == '.jpeg' || extension == '.png') {
      return imageFile;
    }

    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = tempDir.path;
    final String uniqueFileName =
        'profile_pic_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String filePath = '$tempPath/$uniqueFileName';

    final img.Image? decodedImage =
        img.decodeImage(await imageFile.readAsBytes());
    if (decodedImage == null) return imageFile;

    final List<int> jpegBytes = img.encodeJpg(decodedImage, quality: 90);
    final File jpegFile = await File(filePath).writeAsBytes(jpegBytes);
    return jpegFile;
  }

  Future<bool> _isAndroid13OrHigher() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt >= 33;
    }
    return false;
  }

  Future<bool> _refreshToken() async {
    final refreshToken = SharedPreferencesHelper.getString("refresh_token");
    if (refreshToken == null || refreshToken.isEmpty) return false;

    final uri = Uri.parse(
        "https://202.88.237.252:8804/gateway-service/token-service/authentication/tokenRequestByRefreshToken");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json', 'app': 'SA'},
        body: jsonEncode({"refreshToken": refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)["data"];
        SharedPreferencesHelper.saveString(
            "access_token", data["access_token"]);
        SharedPreferencesHelper.saveString(
            "refresh_token", data["refresh_token"]);
        SharedPreferencesHelper.saveString("id_token", data["id_token"]);
        return true;
      } else {
        debugPrint('🔁 Refresh token failed: ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('Exception while refreshing token: $e');
      return false;
    }
  }
}
