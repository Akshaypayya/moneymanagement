import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/profile_page/provider/update_prof_pic_provider.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';
import 'package:money_mangmnt/features/profile_page/repo/profile_repo.dart';

class ProfilePictureController {
  final ProfilePictureRepository _repository;
  final ProfilePictureFileNotifier _profilePictureNotifier;

  ProfilePictureController(this._repository, this._profilePictureNotifier);

  Future<void> pickProfilePicture(WidgetRef ref, BuildContext context) async {
    debugPrint('CONTROLLER: Initiating profile picture selection from gallery');

    try {
      debugPrint('CONTROLLER: Calling repository to pick image');
      final imageFile = await _repository.pickProfileImage(context);

      if (imageFile != null) {
        debugPrint('CONTROLLER: Image selected successfully');
        debugPrint('CONTROLLER: Updating profile state with new image');
        _profilePictureNotifier.setProfilePicture(imageFile);
        debugPrint('CONTROLLER: Profile state updated with new image');
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
      debugPrint('CONTROLLER: Calling repository to capture image');
      final imageFile = await _repository.captureProfileImage(context);

      if (imageFile != null) {
        debugPrint('CONTROLLER: Image captured successfully');
        debugPrint('CONTROLLER: Updating profile state with new image');
        _profilePictureNotifier.setProfilePicture(imageFile);
        debugPrint('CONTROLLER: Profile state updated with new image');
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

    debugPrint('UPLOAD: Image file available');
    debugPrint('UPLOAD: Setting state to loading');
    stateNotifier.setLoading();

    try {
      debugPrint('UPLOAD: Calling repository to upload profile picture');
      final response = await _repository.uploadProfilePicture(imageFile);

      debugPrint('UPLOAD: Repository call completed');
      debugPrint('UPLOAD: Response status: ${response.status}');

      if (response.status.toLowerCase() == 'success') {
        debugPrint('UPLOAD: Upload successful');
        stateNotifier.setSuccess(response.message);

        debugPrint('UPLOAD: Refreshing user profile data');
        await _refreshUserProfile(ref);
      } else {
        debugPrint('UPLOAD: Upload failed: ${response.message}');
        stateNotifier.setError(response.message);
      }
    } catch (e) {
      debugPrint('UPLOAD ERROR: ${e.toString()}');
      stateNotifier
          .setError('Failed to upload profile picture: ${e.toString()}');
    }
  }

  void clearProfilePicture(WidgetRef ref) {
    debugPrint('CONTROLLER: Clearing profile picture');
    _profilePictureNotifier.clearProfilePicture();
    ref.read(profilePictureUploadStateProvider.notifier).reset();
    debugPrint('CONTROLLER: Profile picture cleared');
  }

  Future<void> _refreshUserProfile(WidgetRef ref) async {
    try {
      final userProfileController = ref.read(userProfileControllerProvider);
      if (userProfileController != null) {
        await userProfileController.refreshUserProfile(ref);
        debugPrint('UPLOAD: User profile refreshed successfully');
      }
    } catch (e) {
      debugPrint('UPLOAD: Failed to refresh user profile: ${e.toString()}');
    }
  }
}
