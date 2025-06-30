import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  ConnectivityService() {
    _initializeConnectivity();
  }

  void _initializeConnectivity() {
    checkConnectivity();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
      _handleConnectivityChange(results);
    }, onError: (error) {
      debugPrint('Connectivity error: $error');
      _connectionStatusController.add(false);
    });
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    bool isConnected = _checkConnectionFromResults(results);

    if (isConnected) {
      _verifyInternetConnection().then((hasInternet) {
        _connectionStatusController.add(hasInternet);
      }).catchError((error) {
        debugPrint('Internet verification error: $error');
        _connectionStatusController.add(false);
      });
    } else {
      _connectionStatusController.add(false);
    }
  }

  bool _checkConnectionFromResults(List<ConnectivityResult> results) {
    return results.isNotEmpty &&
        !results.every((result) => result == ConnectivityResult.none);
  }

  Future<bool> checkConnectivity() async {
    try {
      List<ConnectivityResult> connectivityResults =
          await _connectivity.checkConnectivity();

      bool hasConnection = _checkConnectionFromResults(connectivityResults);

      if (hasConnection) {
        // Verify actual internet connectivity
        bool hasInternet = await _verifyInternetConnection();
        _connectionStatusController.add(hasInternet);
        return hasInternet;
      } else {
        _connectionStatusController.add(false);
        return false;
      }
    } catch (e) {
      debugPrint('Check connectivity error: $e');
      _connectionStatusController.add(false);
      return false;
    }
  }

  Future<bool> _verifyInternetConnection() async {
    try {
      // Try to reach a reliable host
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (e) {
      debugPrint('Internet verification error: $e');
      return false;
    }
  }

  Future<bool> _verifyInternetConnectionHttp() async {
    try {
      final client = HttpClient();
      final request = await client
          .getUrl(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      final response =
          await request.close().timeout(const Duration(seconds: 5));

      client.close();
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('HTTP internet verification error: $e');
      return false;
    }
  }

  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController.close();
  }
}
