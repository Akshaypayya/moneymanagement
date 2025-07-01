// import 'dart:async';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/internet_checker/provider/connectivity_provider.dart';

// class ConnectivityStateNotifier extends StateNotifier<bool> {
//   late final StreamSubscription<AsyncValue<bool>> _subscription;

//   ConnectivityStateNotifier(Ref ref) : super(true) {
//     _subscription = ref.listen<AsyncValue<bool>>(
//       connectivityStatusProvider,
//       (previous, next) {
//         next.whenData((isConnected) {
//           if (state != isConnected) {
//             state = isConnected;
//           }
//         });
//       },
//     ) as StreamSubscription<AsyncValue<bool>>;
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }

// final currentConnectivityProvider =
//     StateNotifierProvider<ConnectivityStateNotifier, bool>((ref) {
//   return ConnectivityStateNotifier(ref);
// });
