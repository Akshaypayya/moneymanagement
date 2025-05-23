import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/profile_page/provider/update_prof_pic_provider.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';
import 'package:money_mangmnt/features/profile_page/repo/profile_repo.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePictureController {
  final ProfilePictureRepository _repository;
  final ProfilePictureFileNotifier _profilePictureNotifier;

  ProfilePictureController(this._repository, this._profilePictureNotifier);

  Future<File?> cropImage(File imageFile, WidgetRef ref) async {
    final isDark = ref.watch(isDarkProvider);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 4),
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: AppColors.current(isDark).background,
          backgroundColor: AppColors.current(isDark).background,
          cropStyle: CropStyle.circle,
          toolbarWidgetColor: AppColors.current(isDark).text,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          cropFrameColor: Colors.transparent,
          cropGridColor: Colors.transparent,
          hideBottomControls: true,
          statusBarColor: AppColors.current(isDark).text,
          activeControlsWidgetColor: Colors.black,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
          cropStyle: CropStyle.circle,
        ),
      ],
    );

    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }

  Future<void> pickProfilePicture(WidgetRef ref, BuildContext context) async {
    debugPrint('CONTROLLER: Initiating profile picture selection from gallery');

    try {
      final imageFile = await _repository.pickProfileImage(context);

      if (imageFile != null) {
        debugPrint('CONTROLLER: Image selected successfully');

        final cropped = await cropImage(imageFile, ref);
        if (cropped != null) {
          debugPrint('CONTROLLER: Image cropped successfully');
          _profilePictureNotifier.setProfilePicture(cropped);
          debugPrint('CONTROLLER: Profile state updated with cropped image');
        } else {
          debugPrint('CONTROLLER: Image cropping canceled');
        }
      } else {
        debugPrint('CONTROLLER: No image was selected or permission denied');
      }
    } catch (e) {
      debugPrint('CONTROLLER ERROR: Failed to pick image: ${e.toString()}');
      ref
          .read(profilePictureUploadStateProvider.notifier)
          .setError('Failed to pick image: ${e.toString()}');
    }
  }

  Future<void> captureProfilePicture(
      WidgetRef ref, BuildContext context) async {
    debugPrint('CONTROLLER: Initiating profile picture capture from camera');

    try {
      final imageFile = await _repository.captureProfileImage(context);

      if (imageFile != null) {
        debugPrint('CONTROLLER: Image captured successfully');

        final cropped = await cropImage(imageFile, ref);
        if (cropped != null) {
          debugPrint('CONTROLLER: Image cropped successfully');
          _profilePictureNotifier.setProfilePicture(cropped);
          debugPrint('CONTROLLER: Profile state updated with cropped image');
        } else {
          debugPrint('CONTROLLER: Image cropping canceled');
        }
      } else {
        debugPrint('CONTROLLER: No image was captured or permission denied');
      }
    } catch (e) {
      debugPrint('CONTROLLER ERROR: Failed to capture image: ${e.toString()}');
      ref
          .read(profilePictureUploadStateProvider.notifier)
          .setError('Failed to capture image: ${e.toString()}');
    }
  }

  Future<void> uploadProfilePicture(WidgetRef ref, BuildContext context) async {
    debugPrint('UPLOAD: Starting profile picture upload process');

    final stateNotifier = ref.read(profilePictureUploadStateProvider.notifier);
    final imageFile = ref.read(profilePictureFileProvider);

    if (imageFile == null) {
      debugPrint('UPLOAD: No image file to upload');
      stateNotifier.setError('Please select a profile picture first');
      return;
    }

    stateNotifier.setLoading();

    try {
      final response = await _repository.uploadProfilePicture(imageFile);

      if (response.status.toLowerCase() == 'success') {
        stateNotifier.setSuccess(response.message);
        await _refreshUserProfile(ref);
      } else {
        stateNotifier.setError(response.message);
      }
    } catch (e) {
      stateNotifier
          .setError('Failed to upload profile picture: ${e.toString()}');
    }
  }

  void clearProfilePicture(WidgetRef ref) {
    _profilePictureNotifier.clearProfilePicture();
    ref.read(profilePictureUploadStateProvider.notifier).reset();
  }

  Future<void> _refreshUserProfile(WidgetRef ref) async {
    try {
      final userProfileController = ref.read(userProfileControllerProvider);
      if (userProfileController != null) {
        await userProfileController.refreshUserProfile(ref);
      }
    } catch (e) {
      debugPrint('UPLOAD: Failed to refresh user profile: ${e.toString()}');
    }
  }
}
