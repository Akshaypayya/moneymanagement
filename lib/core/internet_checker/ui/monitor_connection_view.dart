import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/internet_checker/provider/connectivity_provider.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class MonitorConnectionView extends ConsumerStatefulWidget {
  final Widget child;

  const MonitorConnectionView({Key? key, required this.child})
      : super(key: key);

  @override
  ConsumerState<MonitorConnectionView> createState() =>
      _MonitorConnectionViewState();
}

class _MonitorConnectionViewState extends ConsumerState<MonitorConnectionView> {
  bool _showingOverlay = false;
  bool _isReconnected = false;

  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   ref.read(connectivityKeeperProvider);
    // });
  }

  void _handleConnectivityChange(bool isConnected) {
    if (!isConnected && !_showingOverlay) {
      setState(() {
        _showingOverlay = true;
        _isReconnected = false;
      });
    } else if (isConnected && _showingOverlay) {
      setState(() {
        _isReconnected = true;
      });

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _showingOverlay = false;
            _isReconnected = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final connectivityStatus = ref.watch(connectivityStatusProvider);

    return Scaffold(
      body: Stack(
        children: [
          widget.child,
          connectivityStatus.when(
            data: (isConnected) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleConnectivityChange(isConnected);
              });

              return _showingOverlay
                  ? _buildConnectivityOverlay(context, ref)
                  : const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) {
              debugPrint('Connectivity error: $error');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleConnectivityChange(false);
              });

              return _showingOverlay
                  ? _buildConnectivityOverlay(context, ref)
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectivityOverlay(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    final backgroundColor = _isReconnected ? Colors.green : Colors.red;
    final iconData = _isReconnected ? Icons.wifi : Icons.wifi_off;
    final message = _isReconnected ? 'Connected!' : 'No Internet Connection';

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, color: Colors.white, size: 20),
              GapSpace.width15,
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              if (!_isReconnected)
                GestureDetector(
                  onTap: () => _retryConnection(ref),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              // Show checkmark when reconnected
              if (_isReconnected)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _retryConnection(WidgetRef ref) async {
    try {
      await ref.read(connectivityCheckProvider.future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Checking connection...'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      debugPrint('Retry connection error: $e');
    }
  }
}
