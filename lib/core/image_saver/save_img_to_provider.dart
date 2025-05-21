import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:money_mangmnt/core/storage/shared_preference/shared_preference_service.dart';

final imageDownloadProvider =
    StateNotifierProvider<ImageDownloadNotifier, bool>((ref) {
  return ImageDownloadNotifier();
});

final imageFilePathProvider = Provider<String>((ref) {
  return ref.watch(imageDownloadProvider).toString();
});

final imageExistsProvider = Provider.family<bool, String>((ref, key) {
  final cachedImage = SharedPreferencesHelper.getString('image_$key');
  return cachedImage != null && cachedImage.isNotEmpty;
});

final imageBytesProvider = Provider.family<Uint8List?, String>((ref, key) {
  final cachedImage = SharedPreferencesHelper.getString('image_$key');
  if (cachedImage != null && cachedImage.isNotEmpty) {
    try {
      return base64Decode(cachedImage);
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }
  return null;
});

class ImageDownloadNotifier extends StateNotifier<bool> {
  ImageDownloadNotifier() : super(false);

  Future<void> downloadAndSaveImage(String imageUrl, String filename) async {
    try {
      final cachedImage = SharedPreferencesHelper.getString('image_$filename');
      if (cachedImage != null && cachedImage.isNotEmpty) {
        print('Image already cached for: $filename');
        state = true;
        return;
      }

      state = true;

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$filename.jpg';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        final base64Image = base64Encode(response.bodyBytes);
        await SharedPreferencesHelper.saveString(
            'image_$filename', base64Image);

        print('Image saved to: $filePath');
        state = true;
      } else {
        print('Failed to download image. Status code: ${response.statusCode}');
        state = false;
      }
    } catch (e) {
      print('Error during download: $e');
      state = false;
    }
  }

  Future<void> saveBase64Image(String base64Image, String filename) async {
    try {
      await SharedPreferencesHelper.saveString('image_$filename', base64Image);
      print('Base64 image saved for: $filename');
      state = true;
    } catch (e) {
      print('Error saving base64 image: $e');
      state = false;
    }
  }

  Future<void> clearCachedImage(String filename) async {
    try {
      await SharedPreferencesHelper.remove('image_$filename');
      print('Cleared cached image for: $filename');
      state = false;
    } catch (e) {
      print('Error clearing cached image: $e');
    }
  }
}
