import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growk_v2/core/internet_checker/provider/internet_checker_provider.dart';
import 'package:growk_v2/views.dart';

class OfflinePage extends ConsumerStatefulWidget {
  final String? title;
  final String? message;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  const OfflinePage({
    super.key,
    this.title,
    this.message,
    this.onRetry,
    this.showRetryButton = true,
  });

  @override
  ConsumerState<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends ConsumerState<OfflinePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(isDarkProvider);
    final internetStatus = ref.watch(internetStatusProvider);

    return ScalingFactor(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: _buildContent(isDark, internetStatus),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDark, InternetStatus internetStatus) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAnimatedIcon(isDark),
            const SizedBox(height: 40),
            Text(
              widget.title ?? 'You\'re Offline',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              widget.message ??
                  'It looks like you\'re not connected to the internet. Please check your connection and try again.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: isDark ? Colors.grey[300] : Colors.grey[600],
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildConnectionStatus(internetStatus, isDark),
            const SizedBox(height: 32),
            if (widget.showRetryButton) _buildRetryButton(isDark),
            const SizedBox(height: 24),
            _buildTipsSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(bool isDark) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
              border: Border.all(
                color: Colors.red.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 60,
              color: Colors.red,
            ),
          ),
        );
      },
    );
  }

  Widget _buildConnectionStatus(InternetStatus status, bool isDark) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status) {
      case InternetStatus.connected:
        statusColor = Colors.green;
        statusText = 'Connected - Tap retry to continue';
        statusIcon = Icons.wifi;
        break;
      case InternetStatus.checking:
        statusColor = Colors.orange;
        statusText = 'Checking connection...';
        statusIcon = Icons.refresh;
        break;
      case InternetStatus.disconnected:
        statusColor = Colors.red;
        statusText = 'No internet connection';
        statusIcon = Icons.wifi_off;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          status == InternetStatus.checking
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                  ),
                )
              : Icon(
                  statusIcon,
                  size: 20,
                  color: statusColor,
                ),
          const SizedBox(width: 10),
          Text(
            statusText,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: GoogleFonts.poppins().fontFamily,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isRetrying ? null : _handleRetry,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.white : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isRetrying
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Try Again',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
      ),
    );
  }

  Widget _buildTipsSection(bool isDark) {
    final tips = [
      'Check your WiFi connection',
      'Make sure mobile data is enabled',
      'Try moving to a different location',
      'Restart your router if using WiFi',
    ];

    return Column(
      children: [
        Text(
          'Troubleshooting Tips:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...tips.map((tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Future<void> _handleRetry() async {
    setState(() {
      _isRetrying = true;
    });

    await ref.read(internetStatusProvider.notifier).forceCheck();

    widget.onRetry?.call();

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isRetrying = false;
      });
    }
  }
}
