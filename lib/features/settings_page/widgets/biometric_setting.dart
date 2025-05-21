import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/biometric/biometric_provider.dart';
import 'package:money_mangmnt/core/theme/app_theme.dart';

class BiometricSettingTile extends ConsumerWidget {
  const BiometricSettingTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBiometricEnabled = ref.watch(biometricEnabledProvider);
    final isDark = ref.watch(isDarkProvider);

    return FutureBuilder<bool>(
      future: ref.read(biometricServiceProvider).isBiometricsAvailable(),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;

        return SwitchListTile(
          title: Text(
            'Use Biometric Authentication',
            style: TextStyle(
              color: AppColors.current(isDark).text,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            isAvailable
                ? 'Secure your app with fingerprint or face recognition'
                : 'Your device does not support biometric authentication',
            style: TextStyle(
              color: AppColors.current(isDark).labelText,
              fontSize: 12,
            ),
          ),
          value: isAvailable && isBiometricEnabled,
          activeColor: AppColors.current(isDark).primary,
          onChanged: isAvailable
              ? (bool value) async {
                  if (value) {
                    final authenticated =
                        await ref.read(biometricServiceProvider).authenticate();

                    if (authenticated) {
                      ref
                          .read(biometricEnabledProvider.notifier)
                          .toggleBiometric(true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Biometric authentication enabled'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    ref
                        .read(biometricEnabledProvider.notifier)
                        .toggleBiometric(false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Biometric authentication disabled'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                }
              : null,
        );
      },
    );
  }
}
