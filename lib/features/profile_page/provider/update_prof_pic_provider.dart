import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/features/profile_page/controller/profile_controller.dart';
import 'package:growk_v2/features/profile_page/repo/profile_repo.dart';

final profilePictureRepositoryProvider =
    Provider<ProfilePictureRepository>((ref) {
  return ProfilePictureRepository(
    baseUrl: AppUrl.baseUrl,
  );
});

final profilePictureFileProvider =
    StateNotifierProvider<ProfilePictureFileNotifier, File?>((ref) {
  return ProfilePictureFileNotifier();
});

class ProfilePictureFileNotifier extends StateNotifier<File?> {
  ProfilePictureFileNotifier() : super(null);

  void setProfilePicture(File? file) {
    state = file;
  }

  void clearProfilePicture() {
    state = null;
  }
}

final profilePictureControllerProvider =
    Provider<ProfilePictureController>((ref) {
  final repository = ref.watch(profilePictureRepositoryProvider);
  final profilePictureNotifier = ref.watch(profilePictureFileProvider.notifier);
  return ProfilePictureController(repository, profilePictureNotifier);
});

enum UploadStatus { initial, loading, success, error }

class ProfilePictureUploadState {
  final UploadStatus status;
  final String? message;
  final double? uploadProgress;
  final bool shouldShowMessage;

  ProfilePictureUploadState({
    this.status = UploadStatus.initial,
    this.message,
    this.uploadProgress,
    this.shouldShowMessage = false,
  });

  ProfilePictureUploadState copyWith({
    UploadStatus? status,
    String? message,
    double? uploadProgress,
    bool? shouldShowMessage,
  }) {
    return ProfilePictureUploadState(
      status: status ?? this.status,
      message: message ?? this.message,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      shouldShowMessage: shouldShowMessage ?? this.shouldShowMessage,
    );
  }
}

final profilePictureUploadStateProvider = StateNotifierProvider<
    ProfilePictureUploadStateNotifier, ProfilePictureUploadState>((ref) {
  return ProfilePictureUploadStateNotifier();
});

class ProfilePictureUploadStateNotifier
    extends StateNotifier<ProfilePictureUploadState> {
  ProfilePictureUploadStateNotifier() : super(ProfilePictureUploadState());

  void setLoading() {
    state = state.copyWith(
      status: UploadStatus.loading,
      shouldShowMessage: false,
    );
  }

  void setProgress(double progress) {
    state = state.copyWith(uploadProgress: progress);
  }

  void setSuccess(String message) {
    state = state.copyWith(
      status: UploadStatus.success,
      message: message,
      shouldShowMessage: true,
    );
  }

  void setError(String message) {
    state = state.copyWith(
      status: UploadStatus.error,
      message: message,
      shouldShowMessage: true,
    );
  }

  void messageShown() {
    state = state.copyWith(shouldShowMessage: false);
  }

  void reset() {
    state = ProfilePictureUploadState();
  }
}
