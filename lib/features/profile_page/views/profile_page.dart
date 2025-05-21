import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/scaling_factor/scale_factor.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/profile_appbar.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/profile_header.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/user_header_details.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/user_other_details.dart';

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
        appBar: profileAppBar(ref: ref),
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
