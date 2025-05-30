import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/scaling_factor/scale_factor.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/profile_page/provider/user_details_provider.dart';
import 'package:growk_v2/features/profile_page/views/widget/edit_profile_header_body.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_appbar.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_header.dart';
import 'package:growk_v2/features/profile_page/views/widget/user_header_details.dart';
import 'package:growk_v2/features/profile_page/views/widget/user_other_details.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<void> _refreshProfile() async {
    await ref.read(userProfileControllerProvider).refreshUserProfile(ref);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).scaffoldBackground,
        // appBar: profileAppBar(ref: ref),
        body: RefreshIndicator(
          key: _refreshKey,
          onRefresh: _refreshProfile,
          child: Container(
            color: isDark ? Colors.black : Colors.white,
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const EditProfileHeaderBody(),
                    const ProfilePicture(),
                    UserHeaderDetails(),
                    UserOtherDetails(),
                    const SizedBox(height: 130),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
