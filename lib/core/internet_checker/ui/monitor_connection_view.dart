import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/internet_checker/provider/connectivity_provider.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class MonitorConnectionView extends ConsumerWidget {
  final Widget child;

  const MonitorConnectionView({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return Scaffold(
      body: Stack(
        children: [
          child,
          connectivityStatus.when(
            data: (isConnected) => isConnected
                ? const SizedBox.shrink()
                : _buildNoInternetOverlay(context, ref),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildNoInternetOverlay(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: isDark ? Colors.black : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off, color: Colors.white),
            GapSpace.width15,
            Text(
              'No Internet Connection',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
