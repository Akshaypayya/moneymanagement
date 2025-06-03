import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/internet_checker/provider/internet_checker_provider.dart';
import 'package:growk_v2/core/widgets/reusable_snackbar.dart';

extension InternetRef on WidgetRef {
  InternetStatus get internetStatus => read(internetStatusProvider);

  bool get isConnected => internetStatus == InternetStatus.connected;

  bool get isDisconnected => internetStatus == InternetStatus.disconnected;

  bool get isCheckingConnection => internetStatus == InternetStatus.checking;

  Future<void> checkInternetConnection() async {
    await read(internetStatusProvider.notifier).forceCheck();
  }
}

extension InternetContext on BuildContext {
  void showNoInternetSnackBar() {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi_off, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('No internet connection'),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void showConnectionRestoredSnackBar() {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.wifi, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Internet connection restored'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

mixin InternetAwareMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  void onInternetConnected() {
    debugPrint('INTERNET MIXIN: Connection restored');
  }

  void onInternetDisconnected() {
    debugPrint('INTERNET MIXIN: Connection lost');
  }

  void onInternetStatusChanged(
      InternetStatus previous, InternetStatus current) {
    if (previous == InternetStatus.disconnected &&
        current == InternetStatus.connected) {
      onInternetConnected();
    } else if (previous == InternetStatus.connected &&
        current == InternetStatus.disconnected) {
      onInternetDisconnected();
    }
  }

  void setupInternetListener() {
    ref.listen<InternetStatus>(internetStatusProvider, (previous, current) {
      if (previous != null && previous != current) {
        onInternetStatusChanged(previous, current);
      }
    });
  }

  bool canMakeNetworkRequest() {
    return ref.read(internetStatusProvider) == InternetStatus.connected;
  }

  Future<T?> executeWithInternet<T>(
    Future<T> Function() function, {
    VoidCallback? onNoInternet,
    bool showSnackbar = true,
  }) async {
    if (!canMakeNetworkRequest()) {
      if (showSnackbar && mounted) {
        context.showNoInternetSnackBar();
      }
      onNoInternet?.call();
      return null;
    }

    try {
      return await function();
    } catch (e) {
      debugPrint('INTERNET MIXIN: Network request failed: $e');
      rethrow;
    }
  }
}

class InternetUtils {
  static bool isNetworkError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('network') ||
        errorString.contains('connection') ||
        errorString.contains('timeout') ||
        errorString.contains('unreachable') ||
        errorString.contains('failed host lookup');
  }

  static String getNetworkErrorMessage(dynamic error) {
    if (isNetworkError(error)) {
      return 'Please check your internet connection and try again.';
    }
    return 'Something went wrong. Please try again.';
  }

  static void showErrorMessage(
    BuildContext context,
    WidgetRef ref,
    dynamic error, {
    String? customMessage,
  }) {
    final isConnected =
        ref.read(internetStatusProvider) == InternetStatus.connected;

    String message;
    SnackType type;

    if (!isConnected) {
      message = 'No internet connection. Please check your network.';
      type = SnackType.error;
    } else if (isNetworkError(error)) {
      message = customMessage ?? getNetworkErrorMessage(error);
      type = SnackType.error;
    } else {
      message = customMessage ?? 'Something went wrong. Please try again.';
      type = SnackType.error;
    }

    showGrowkSnackBar(
      context: context,
      ref: ref,
      message: message,
      type: type,
    );
  }
}
