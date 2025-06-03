import 'package:growk_v2/core/internet_checker/provider/internet_checker_provider.dart';
import 'package:growk_v2/core/internet_checker/view/widgets/no_internet_diaog.dart';
import 'package:growk_v2/views.dart';

class InternetCheckerWidget extends ConsumerStatefulWidget {
  final Widget child;
  final bool showDialog;
  final bool showSnackBar;
  final VoidCallback? onConnected;
  final VoidCallback? onDisconnected;

  const InternetCheckerWidget({
    super.key,
    required this.child,
    this.showDialog = true,
    this.showSnackBar = false,
    this.onConnected,
    this.onDisconnected,
  });

  @override
  ConsumerState<InternetCheckerWidget> createState() =>
      _InternetCheckerWidgetState();
}

class _InternetCheckerWidgetState extends ConsumerState<InternetCheckerWidget> {
  InternetStatus? _previousStatus;
  bool _dialogShown = false;

  @override
  Widget build(BuildContext context) {
    final internetStatus = ref.watch(internetStatusProvider);

    ref.listen<InternetStatus>(internetStatusProvider, (previous, current) {
      _handleStatusChange(previous, current);
    });

    return Stack(
      children: [
        widget.child,
        _buildStatusIndicator(internetStatus),
      ],
    );
  }

  void _handleStatusChange(InternetStatus? previous, InternetStatus current) {
    if (_previousStatus == null) {
      _previousStatus = current;
      return;
    }

    if (previous != null && previous != current) {
      switch (current) {
        case InternetStatus.connected:
          _handleConnected();
          break;
        case InternetStatus.disconnected:
          _handleDisconnected();
          break;
        case InternetStatus.checking:
          break;
      }
    }

    _previousStatus = current;
  }

  void _handleConnected() {
    debugPrint('INTERNET CHECKER: Connection restored');

    if (_dialogShown) {
      Navigator.of(context, rootNavigator: true).pop();
      _dialogShown = false;
    }

    if (widget.showSnackBar) {
      _showConnectionSnackBar(true);
    }

    widget.onConnected?.call();
  }

  void _handleDisconnected() {
    debugPrint('INTERNET CHECKER: Connection lost');

    if (widget.showDialog && !_dialogShown) {
      _showNoInternetDialog();
    }

    if (widget.showSnackBar) {
      _showConnectionSnackBar(false);
    }

    widget.onDisconnected?.call();
  }

  void _showNoInternetDialog() {
    _dialogShown = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NoInternetDialog(
        onRetry: () => ref.read(internetStatusProvider.notifier).forceCheck(),
        onDismiss: () {
          _dialogShown = false;
        },
      ),
    ).then((_) {
      _dialogShown = false;
    });
  }

  void _showConnectionSnackBar(bool isConnected) {
    if (!mounted) return;

    final message =
        isConnected ? 'Internet connection restored' : 'No internet connection';

    final backgroundColor = isConnected ? Colors.green : Colors.red;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isConnected ? Icons.wifi : Icons.wifi_off,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: isConnected ? 2 : 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(InternetStatus status) {
    if (status == InternetStatus.connected) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 0,
      right: 0,
      child: Container(
        height: 25,
        color: status == InternetStatus.checking ? Colors.orange : Colors.red,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (status == InternetStatus.checking)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                const Icon(
                  Icons.wifi_off,
                  color: Colors.white,
                  size: 16,
                ),
              const SizedBox(width: 8),
              Text(
                status == InternetStatus.checking
                    ? 'Checking connection...'
                    : 'No internet connection',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
