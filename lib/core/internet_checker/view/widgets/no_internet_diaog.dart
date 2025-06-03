import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/internet_checker/provider/internet_checker_provider.dart';
import 'package:growk_v2/views.dart';

class NoInternetDialog extends ConsumerStatefulWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  const NoInternetDialog({
    super.key,
    this.onRetry,
    this.onDismiss,
  });

  @override
  ConsumerState<NoInternetDialog> createState() => _NoInternetDialogState();
}

class _NoInternetDialogState extends ConsumerState<NoInternetDialog> {
  bool _isRetrying = false;

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final internetStatus = ref.watch(internetStatusProvider);

    ref.listen<InternetStatus>(internetStatusProvider, (previous, current) {
      if (current == InternetStatus.connected && mounted) {
        widget.onDismiss?.call();
        Navigator.of(context).pop();
      }
    });

    return WillPopScope(
      onWillPop: () async => false,
      child: ScalingFactor(
        child: AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wifi_off_rounded,
                  size: 40,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Please check your internet connection and try again. Make sure you\'re connected to WiFi or mobile data.',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              _buildConnectionStatus(internetStatus, isDark),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: _isRetrying
                          ? null
                          : () {
                              widget.onDismiss?.call();
                              Navigator.of(context).pop();
                            },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Continue Offline',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isRetrying ? null : _handleRetry,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isRetrying
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Retry',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionStatus(InternetStatus status, bool isDark) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case InternetStatus.connected:
        statusColor = Colors.green;
        statusText = 'Connected';
        statusIcon = Icons.wifi;
        break;
      case InternetStatus.checking:
        statusColor = Colors.orange;
        statusText = 'Checking...';
        statusIcon = Icons.refresh;
        break;
      case InternetStatus.disconnected:
        statusColor = Colors.red;
        statusText = 'Disconnected';
        statusIcon = Icons.wifi_off;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          status == InternetStatus.checking
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                )
              : Icon(
                  statusIcon,
                  size: 16,
                  color: statusColor,
                ),
          const SizedBox(width: 6),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRetry() async {
    setState(() {
      _isRetrying = true;
    });

    widget.onRetry?.call();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRetrying = false;
      });
    }
  }
}
