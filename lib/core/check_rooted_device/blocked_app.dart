import 'dart:io';
import 'package:flutter/services.dart';
import 'package:growk_v2/core/check_rooted_device/check_rooted_device.dart';
import '../../views.dart';

class BlockedApp extends ConsumerWidget {
  const BlockedApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final errorText = ref.watch(jailbreakErrorProvider);
    final isDark = ref.watch(isDarkProvider);

    final green = const Color(0xFF00C853); // vivid green

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.current(isDark).background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),

                Icon(Icons.lock_person_rounded, color: green, size: 64),
                const SizedBox(height: 16),

                ReusableText(
                  text: "DEVICE SECURITY RISK",
                  textAlign: TextAlign.center,
                  style: AppTextStyle.current(isDark).titleRegular.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 12),

                ReusableText(
                  text:
                  "We've detected potential security issues with your device. For your safety, access to this app has been restricted.",
                  textAlign: TextAlign.center,
                  maxLines: 10,
                  style: AppTextStyle.current(isDark).bodySmall.copyWith(
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white12 : Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    child: ReusableText(
                      maxLines: 10,
                      text: errorText,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.current(isDark).bodySmall.copyWith(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
                GrowkButton(title: "Exit App",onTap: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else {
                    exit(0);
                  }
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
