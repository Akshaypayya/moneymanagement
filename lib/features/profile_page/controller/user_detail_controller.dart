import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/profile_page/provider/user_details_provider.dart';
import 'package:growk_v2/features/profile_page/repo/user_details_repo.dart';

class UserProfileController {
  final UserDetailRepository _repository;

  UserProfileController(this._repository);

  Future<void> getUserProfile(WidgetRef ref) async {
    debugPrint('PROFILE: Fetching user profile data');
    final stateNotifier = ref.read(userProfileStateProvider.notifier);

    stateNotifier.setLoading();

    try {
      debugPrint('PROFILE: Calling repository to get user data');
      final response = await _repository.getUserProfile();

      debugPrint('PROFILE: Repository call completed');

      if (response.status == "Success") {
        if (response.userData != null) {
          debugPrint('PROFILE: Successfully got user profile data');
          stateNotifier.setSuccess(response.userData!);
        } else {
          debugPrint('PROFILE: Success response but userData is null');
          stateNotifier.setError('User data not found in response');
        }
      } else {
        // debugPrint('PROFILE: Failed to get user profile: ${response.message}');
        stateNotifier.setError(response.message ?? 'Unknown error occurred');
      }
    } catch (e) {
      debugPrint('PROFILE ERROR: ${e.toString()}');
      stateNotifier.setError('Failed to get user profile: ${e.toString()}');
    }
  }

  Future<void> refreshUserProfile(WidgetRef ref) async {
    debugPrint('PROFILE: Refreshing user profile data');
    await getUserProfile(ref);
  }
}
