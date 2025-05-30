import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/views.dart';

class EditProfileHeaderBody extends ConsumerStatefulWidget {
  const EditProfileHeaderBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileHeaderBodyState();
}

class _EditProfileHeaderBodyState extends ConsumerState<EditProfileHeaderBody> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.editUserDetailsScreen);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}
