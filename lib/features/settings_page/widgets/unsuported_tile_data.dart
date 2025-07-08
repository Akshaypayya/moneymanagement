import 'package:growk_v2/views.dart';

Widget biometricUnsupportedTileBuilder(bool isDark, WidgetRef ref) {
  final texts = ref.watch(appTextsProvider);
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    decoration: BoxDecoration(
      color: isDark ? Colors.grey.shade900 : Colors.white,
      border: Border(
        bottom: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          width: 1,
        ),
      ),
    ),
    child: Row(
      children: [
        Icon(
          Icons.fingerprint,
          size: 30,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                texts.bioAuth,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                texts.bioNotAvail,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.info_outline,
          size: 20,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      ],
    ),
  );
}
