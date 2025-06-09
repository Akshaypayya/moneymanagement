import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  StreamController<bool> connectionStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => connectionStatusController.stream;

  ConnectivityService() {
    checkConnectivity();

    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // bool isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);
      bool isConnected = results != ConnectivityResult.none;
      connectionStatusController.add(isConnected);
    });
  }

  Future<bool> checkConnectivity() async {
    var connectivityResults = await _connectivity.checkConnectivity();
    // bool isConnected = connectivityResults.isNotEmpty &&
    //     !connectivityResults.contains(ConnectivityResult.none);
    bool isConnected = connectivityResults != ConnectivityResult.none;
    connectionStatusController.add(isConnected);
    connectionStatusController.add(isConnected);
    return isConnected;
  }

  void dispose() {
    connectionStatusController.close();
  }
}
