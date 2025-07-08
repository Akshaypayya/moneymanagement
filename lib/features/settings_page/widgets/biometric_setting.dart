import 'package:growk_v2/core/biometric/biometric_provider.dart';
import 'package:growk_v2/views.dart';

class BiometricSettingsTile extends ConsumerWidget {
  const BiometricSettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final isBiometricEnabled = ref.watch(biometricEnabledProvider);
    final isBiometricSupportedAsync = ref.watch(biometricSupportedProvider);

    return isBiometricSupportedAsync.when(
      data: (isSupported) {
        if (!isSupported) {
          return biometricUnsupportedTileBuilder(isDark, ref);
        }

        return biomtricToggleTileBuilder(
            context, ref, isDark, isBiometricEnabled);
      },
      loading: () => biomtricLoadingTile(isDark, ref),
      error: (_, __) => biometricUnsupportedTileBuilder(isDark, ref),
    );
  }
}
