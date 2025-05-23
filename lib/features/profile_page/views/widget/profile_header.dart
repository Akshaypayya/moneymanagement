import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/profile_page/model/user_details_model.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';

class ProfilePicture extends ConsumerStatefulWidget {
  const ProfilePicture({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends ConsumerState<ProfilePicture> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.watch(userProfileControllerProvider).getUserProfile(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileStateProvider);

    final userData = profileState.userData;

    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          chooseProfPicUi(
            userData: userData,
          ),
        ],
      ),
    );
  }

  Widget chooseProfPicUi({
    required UserData? userData,
  }) {
    final profileState = ref.watch(userProfileStateProvider);
    final isLoading = profileState.status == UserProfileStatus.loading;
    final isDark = ref.watch(isDarkProvider);
    return isLoading
        ? Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
                child: CircularProgressIndicator(
              color: isDark ? Colors.white : Colors.black,
            )),
          )
        : Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              image: DecorationImage(
                image: userData == null
                    ? AssetImage(
                        'assets/profile_image.png',
                      )
                    : userData.profilePicture == null
                        ? AssetImage(
                            'assets/profile_default_image.png',
                          )
                        : MemoryImage(
                            base64Decode(userData.profilePicture ?? "")),
                fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          );
  }
}
