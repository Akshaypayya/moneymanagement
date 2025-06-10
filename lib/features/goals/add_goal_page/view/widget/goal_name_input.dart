import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/features/goals/add_goal_page/provider/add_goal_provider.dart';

class GoalNameInput extends ConsumerWidget {
  const GoalNameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final goalName = ref.watch(goalNameProvider);

    return Center(
      child: SizedBox(
        width: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter Goal Name',
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (value) {
                ref.read(goalNameProvider.notifier).state = value;
              },
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              cursorColor: isDark ? Colors.white : Colors.black,
              decoration: InputDecoration(
                hintText: 'Eg: Education, Home, Wedding',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
