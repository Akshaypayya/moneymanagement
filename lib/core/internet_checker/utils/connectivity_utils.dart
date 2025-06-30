import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityUtils {
  static const Duration defaultTimeout = Duration(seconds: 5);

  static String getConnectionTypeName(List<ConnectivityResult> results) {
    if (results.isEmpty || results.every((r) => r == ConnectivityResult.none)) {
      return 'No Connection';
    }

    if (results.contains(ConnectivityResult.wifi)) {
      return 'WiFi';
    } else if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile Data';
    } else if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    } else if (results.contains(ConnectivityResult.bluetooth)) {
      return 'Bluetooth';
    } else if (results.contains(ConnectivityResult.vpn)) {
      return 'VPN';
    } else {
      return 'Connected';
    }
  }

  static Future<bool> hasConnection() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      return connectivityResult.isNotEmpty &&
          !connectivityResult.every((r) => r == ConnectivityResult.none);
    } catch (e) {
      debugPrint('Quick connectivity check error: $e');
      return false;
    }
  }

  static Future<bool> hasInternetConnection({
    String host = 'google.com',
    Duration timeout = defaultTimeout,
  }) async {
    try {
      final result = await InternetAddress.lookup(host).timeout(timeout);
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Internet connectivity check error: $e');
      return false;
    }
  }

  static Future<bool> hasReliableInternetConnection({
    Duration timeout = defaultTimeout,
  }) async {
    final hosts = ['google.com', 'cloudflare.com', '8.8.8.8'];

    for (String host in hosts) {
      try {
        if (await hasInternetConnection(host: host, timeout: timeout)) {
          return true;
        }
      } catch (e) {
        debugPrint('Failed to reach $host: $e');
        continue;
      }
    }

    return false;
  }

  static Future<ConnectionQuality> getConnectionQuality() async {
    try {
      final stopwatch = Stopwatch()..start();
      bool hasInternet = await hasInternetConnection(
        timeout: const Duration(seconds: 3),
      );
      stopwatch.stop();

      if (!hasInternet) {
        return ConnectionQuality.none;
      }

      final milliseconds = stopwatch.elapsedMilliseconds;

      if (milliseconds < 500) {
        return ConnectionQuality.excellent;
      } else if (milliseconds < 1000) {
        return ConnectionQuality.good;
      } else if (milliseconds < 2000) {
        return ConnectionQuality.fair;
      } else {
        return ConnectionQuality.poor;
      }
    } catch (e) {
      debugPrint('Connection quality check error: $e');
      return ConnectionQuality.none;
    }
  }

  static Stream<ConnectivityStatus> monitorConnectivity({
    Duration debounceTime = const Duration(milliseconds: 500),
  }) async* {
    ConnectivityStatus? lastStatus;

    await for (final results in Connectivity().onConnectivityChanged) {
      final hasConnection = results.isNotEmpty &&
          !results.every((r) => r == ConnectivityResult.none);

      if (hasConnection) {
        await Future.delayed(debounceTime);

        final hasInternet = await hasInternetConnection();
        final connectionType = getConnectionTypeName(results);
        final quality = await getConnectionQuality();

        final status = ConnectivityStatus(
          isConnected: hasInternet,
          connectionType: connectionType,
          quality: quality,
          results: results,
        );

        if (lastStatus?.isConnected != status.isConnected) {
          lastStatus = status;
          yield status;
        }
      } else {
        final status = ConnectivityStatus(
          isConnected: false,
          connectionType: 'No Connection',
          quality: ConnectionQuality.none,
          results: results,
        );

        if (lastStatus?.isConnected != false) {
          lastStatus = status;
          yield status;
        }
      }
    }
  }
}

enum ConnectionQuality {
  none,
  poor,
  fair,
  good,
  excellent,
}

class ConnectivityStatus {
  final bool isConnected;
  final String connectionType;
  final ConnectionQuality quality;
  final List<ConnectivityResult> results;

  ConnectivityStatus({
    required this.isConnected,
    required this.connectionType,
    required this.quality,
    required this.results,
  });

  @override
  String toString() {
    return 'ConnectivityStatus(isConnected: $isConnected, type: $connectionType, quality: $quality)';
  }
}
