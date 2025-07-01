import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/internet_checker/service/connectivity_service.dart';

final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();

  ref.onDispose(() {
    service.dispose();
  });

  return service;
});

final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.connectionStatus;
});

final connectivityCheckProvider = FutureProvider<bool>((ref) async {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return await connectivityService.checkConnectivity();
});

// final currentConnectivityProvider = StateProvider<bool>((ref) {
//   return true;
// });

// final connectivityKeeperProvider = Provider<void>((ref) {
//   final connectivityStream = ref.watch(connectivityStatusProvider);

//   connectivityStream.whenData((isConnected) {
//     Future.microtask(() {
//       ref.read(currentConnectivityProvider.notifier).state = isConnected;
//     });
//   });

//   return;
// });
