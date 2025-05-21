import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/views.dart';

PreferredSizeWidget profileAppBar({
  required WidgetRef ref,
  VoidCallback? onTap,
}) {
  final isDark = ref.watch(isDarkProvider);

  return GrowkAppBar(
    title: '',
    isBackBtnNeeded: false,
    isActionBtnNeeded: true,
    actionWidget: Builder(
      builder: (context) => GestureDetector(
        onTap: onTap ??
            () {
              Navigator.pushNamed(context, AppRouter.editUserDetailsScreen);
            },
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isDark
                    ? 'assets/edit_profile_dark.png'
                    : 'assets/edit_profile_light.png',
                height: 16,
              ),
              const SizedBox(width: 7),
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
