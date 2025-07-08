import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/views.dart';

class UserHeaderDetails extends ConsumerStatefulWidget {
  const UserHeaderDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserHeaderDetailsState();
}

class _UserHeaderDetailsState extends ConsumerState<UserHeaderDetails> {
  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final profileState = ref.watch(userProfileStateProvider);
    final userData = profileState.userData;
    final isLoading = profileState.status == UserProfileStatus.loading;
    final texts = ref.watch(appTextsProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            // isLoading
            //     ? Container(
            //         width: 200,
            //         height: 24,
            //         decoration: BoxDecoration(
            //           color: isDark ? Colors.grey[700] : Colors.grey[300],
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       )
            //     :
            Text(
              userData?.userName ?? texts.userName,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // isLoading
            //     ? Container(
            //         width: 180,
            //         height: 16,
            //         decoration: BoxDecoration(
            //           color: isDark ? Colors.grey[700] : Colors.grey[300],
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       )
            //     :
            Text(
              userData?.emailId ?? 'email@example.com',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            // isLoading
            //     ? Container(
            //         width: 120,
            //         height: 16,
            //         decoration: BoxDecoration(
            //           color: isDark ? Colors.grey[700] : Colors.grey[300],
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       )
            //     :
            Text(
              '+966 ${userData?.cellNo ?? '560000000'}',
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
