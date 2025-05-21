import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_mangmnt/core/constants/app_images.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';

final autoDepositProvider = StateProvider<bool>((ref) => false);

class AutoDepositOption extends ConsumerWidget {
  const AutoDepositOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isChecked = ref.watch(autoDepositProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              ref.read(autoDepositProvider.notifier).state = value ?? false;
            },
            activeColor: Colors.teal,
            side: BorderSide(
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () {
              ref.read(autoDepositProvider.notifier).state = !isChecked;
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      children: [
                        const TextSpan(
                          text:
                              'Enable automatic gold deposit when your investment amount reaches ',
                        ),
                        WidgetSpan(
                          child: Image.asset(
                            AppImages.sarSymbol,
                            height: 13,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        const TextSpan(
                          text: ' 300',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
