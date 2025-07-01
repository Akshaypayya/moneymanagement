import 'package:growk_v2/views.dart';

import '../../../core/biometric/biometric_provider.dart';

Widget biomtricToggleTileBuilder(
    BuildContext context, WidgetRef ref, bool isDark, bool isEnabled) {
  final biometricTypesAsync = ref.watch(biometricTypesProvider);

  return biometricTypesAsync.when(
    data: (types) {
      final biometricName =
          types.isNotEmpty ? types.first : 'Biometric Authentication';

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  getIconForBiometricType(types),
                  size: 30,
                  color: isDark ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      biometricName,
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Unlock the app using your biometrics',
                      style: TextStyle(
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Switch.adaptive(
              value: isEnabled,
              onChanged: (value) async {
                if (value) {
                  final biometricService = ref.read(biometricServiceProvider);
                  final result = await biometricService
                      .authenticate('Authenticate to enable biometric login');

                  if (result.success) {
                    ref
                        .read(biometricEnabledProvider.notifier)
                        .toggleBiometric(true);
                    if (context.mounted) {
                      showGrowkSnackBar(
                        context: context,
                        ref: ref,
                        message: 'Biometric authentication enabled',
                        type: SnackType.success,
                      );
                    }
                  } else {
                    showGrowkSnackBar(
                      context: context,
                      ref: ref,
                      message: 'Failed to enable biometrics: ${result.message}',
                      type: SnackType.error,
                    );
                  }
                } else {
                  ref
                      .read(biometricEnabledProvider.notifier)
                      .toggleBiometric(false);
                  showGrowkSnackBar(
                    context: context,
                    ref: ref,
                    message: 'Biometric authentication disabled',
                    type: SnackType.error,
                  );
                }
              },
              // activeColor: Colors.teal,
              // activeTrackColor: Colors.teal.withOpacity(0.5),
              activeColor: isDark ? Colors.black : Colors.white,
              activeTrackColor: isDark ? Colors.white : Colors.black,
              inactiveThumbColor: isDark ? Colors.black : Colors.white,
              inactiveTrackColor: isDark ? Colors.grey : Colors.black,
            ),
          ],
        ),
      );
    },
    loading: () => biomtricLoadingTile(isDark),
    error: (_, __) => biometricUnsupportedTileBuilder(isDark),
  );
}
