import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/theme/app_theme.dart';
import 'package:growk_v2/core/biometric/biometric_provider.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';

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
          return _buildUnsupportedTile(isDark);
        }

        return _buildToggleTile(context, ref, isDark, isBiometricEnabled);
      },
      loading: () => _buildLoadingTile(isDark),
      error: (_, __) => _buildUnsupportedTile(isDark),
    );
  }

  Widget _buildToggleTile(
      BuildContext context, WidgetRef ref, bool isDark, bool isEnabled) {
    final biometricTypesAsync = ref.watch(biometricTypesProvider);

    return biometricTypesAsync.when(
      data: (types) {
        final biometricName =
            types.isNotEmpty ? types.first : 'Biometric Authentication';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          // decoration: BoxDecoration(
          //   color: isDark ? Colors.grey.shade900 : Colors.white,
          //   border: Border(
          //     bottom: BorderSide(
          //       color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          //       width: 1,
          //     ),
          //   ),
          // ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _getIconForBiometricType(types),
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
                      _showSnackBar(
                          context, 'Biometric authentication enabled', ref);
                    } else {
                      _showSnackBar(context,
                          'Failed to enable biometrics: ${result.message}', ref,
                          isError: true);
                    }
                  } else {
                    ref
                        .read(biometricEnabledProvider.notifier)
                        .toggleBiometric(false);
                    _showSnackBar(
                        context, 'Biometric authentication disabled', ref);
                  }
                },
                activeColor: Colors.teal,
                activeTrackColor: Colors.teal.withOpacity(0.5),
              ),
            ],
          ),
        );
      },
      loading: () => _buildLoadingTile(isDark),
      error: (_, __) => _buildUnsupportedTile(isDark),
    );
  }

  Widget _buildLoadingTile(bool isDark) {
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
            color: isDark ? Colors.white : Colors.black,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Biometric Authentication',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Checking availability...',
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedTile(bool isDark) {
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
                  'Biometric Authentication',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Not available on this device',
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

  IconData _getIconForBiometricType(List<String> types) {
    if (types.isEmpty) {
      return Icons.fingerprint;
    }

    if (types.any((type) => type.toLowerCase().contains('face'))) {
      return Icons.face;
    } else if (types.any((type) => type.toLowerCase().contains('iris'))) {
      return Icons.remove_red_eye;
    } else {
      return Icons.fingerprint;
    }
  }

  void _showSnackBar(BuildContext context, String message, WidgetRef ref,
      {bool isError = false}) {
    showGrowkSnackBar(
      context: context,
      ref: ref,
      message: message.contains('app configuration issue')
          ? 'Could not enable biometrics due to app configuration. Please restart the app.'
          : message,
      type: SnackType.error,
    );
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text(message.contains('app configuration issue')
    //         ? 'Could not enable biometrics due to app configuration. Please restart the app.'
    //         : message),
    //     backgroundColor: isError ? Colors.red : Colors.black,
    //     duration: const Duration(seconds: 2),
    //     action: message.contains('app configuration issue')
    //         ? SnackBarAction(
    //             label: 'OK',
    //             textColor: Colors.white,
    //             onPressed: () {},
    //           )
    //         : null,
    //   ),
    // );
  }
}
