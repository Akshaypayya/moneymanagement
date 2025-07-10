import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/constants/app_images.dart';
import 'package:growk_v2/core/constants/common_providers.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart'; // Import the main provider file

class AutoDepositOption extends ConsumerWidget {
  const AutoDepositOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isChecked = ref.watch(autoDepositProvider);
    final texts = ref.watch(appTextsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: isChecked,
            onChanged: (value) {
              final newValue = value ?? false;
              ref.read(autoDepositProvider.notifier).state = newValue;
              print('Auto Deposit changed to: $newValue');
              print(
                  'autoDepositProvider state is now: ${ref.read(autoDepositProvider)}');
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
              final newValue = !isChecked;
              ref.read(autoDepositProvider.notifier).state = newValue;
              print('Auto Deposit toggled to: $newValue');
              print(
                  'autoDepositProvider state is now: ${ref.read(autoDepositProvider)}');
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
                        TextSpan(
                          text: texts.autoDepositEnabled,
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
