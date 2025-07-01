import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/core/internet_checker/provider/connectivity_provider.dart';
import 'package:growk_v2/core/theme/app_theme.dart';

class EnhancedConnectivityOverlay extends ConsumerStatefulWidget {
  final Widget child;
  final Duration reconnectedDisplayDuration;
  final bool showConnectionType;
  final bool showPulseAnimation;

  const EnhancedConnectivityOverlay({
    Key? key,
    required this.child,
    this.reconnectedDisplayDuration = const Duration(milliseconds: 2000),
    this.showConnectionType = true,
    this.showPulseAnimation = true,
  }) : super(key: key);

  @override
  ConsumerState<EnhancedConnectivityOverlay> createState() =>
      _EnhancedConnectivityOverlayState();
}

class _EnhancedConnectivityOverlayState
    extends ConsumerState<EnhancedConnectivityOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _colorController;
  late AnimationController _pulseController;
  late Animation<double> _slideAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _pulseAnimation;

  bool _showingOverlay = false;
  bool _isReconnected = false;
  String _connectionType = 'Unknown';

  @override
  void initState() {
    super.initState();

    // Future.microtask(() {
    //   ref.read(connectivityKeeperProvider);
    // });

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _colorController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.red.shade600,
      end: Colors.green.shade600,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _colorController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _handleConnectivityChange(bool isConnected,
      {String connectionType = 'Unknown'}) {
    setState(() {
      _connectionType = connectionType;
    });

    if (!isConnected && !_showingOverlay) {
      // Connection lost
      setState(() {
        _showingOverlay = true;
        _isReconnected = false;
      });
      _colorController.reset();
      _slideController.forward();

      if (widget.showPulseAnimation) {
        _pulseController.repeat(reverse: true);
      }
    } else if (isConnected && _showingOverlay && !_isReconnected) {
      // Connection restored
      setState(() {
        _isReconnected = true;
      });

      _pulseController.stop();
      _pulseController.reset();

      // Animate to green
      _colorController.forward().then((_) {
        // Show success pulse
        if (widget.showPulseAnimation) {
          _pulseController.forward().then((_) {
            _pulseController.reverse();
          });
        }

        // Wait and then hide
        Future.delayed(widget.reconnectedDisplayDuration, () {
          if (mounted) {
            _slideController.reverse().then((_) {
              if (mounted) {
                setState(() {
                  _showingOverlay = false;
                  _isReconnected = false;
                });
                _colorController.reset();
              }
            });
          }
        });
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
              // Get connection type information
              String connectionType =
                  'WiFi'; // You can get this from ConnectivityUtils

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleConnectivityChange(isConnected,
                    connectionType: connectionType);
              });

              return _showingOverlay
                  ? _buildConnectivityOverlay()
                  : const SizedBox.shrink();
            },
            loading: () => const SizedBox.shrink(),
            error: (error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleConnectivityChange(false);
              });

              return _showingOverlay
                  ? _buildConnectivityOverlay()
                  : const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConnectivityOverlay() {
    return AnimatedBuilder(
      animation:
          Listenable.merge([_slideAnimation, _colorAnimation, _pulseAnimation]),
      builder: (context, child) {
        final backgroundColor = _isReconnected
            ? (_colorAnimation.value ?? Colors.green.shade600)
            : Colors.red.shade600;

        final scale = widget.showPulseAnimation ? _pulseAnimation.value : 1.0;

        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 120),
          child: Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Transform.scale(
              scale: scale,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      backgroundColor,
                      backgroundColor.withOpacity(0.8),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: SafeArea(
                  child: _buildOverlayContent(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverlayContent() {
    if (_isReconnected) {
      return _buildReconnectedContent();
    } else {
      return _buildDisconnectedContent();
    }
  }

  Widget _buildDisconnectedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              const Icon(Icons.wifi_off, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (widget.showConnectionType)
                      Text(
                        'Check your network settings',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildRetryButton(),
      ],
    );
  }

  Widget _buildReconnectedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Connected!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (widget.showConnectionType)
                Text(
                  'Connected via $_connectionType',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: _retryConnection,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retryConnection() async {
    try {
      // Show loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text('Checking connection...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      // Trigger connectivity check
      await ref.read(connectivityCheckProvider.future);
    } catch (e) {
      debugPrint('Retry connection error: $e');
    }
  }
}
