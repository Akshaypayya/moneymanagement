// import 'package:flutter_animated_icons/flutter_animated_icons.dart';
// import 'package:growk_v2/core/check_rooted_device/blocked_app.dart';
// import 'package:growk_v2/core/check_rooted_device/check_rooted_device.dart';
// import '../../views.dart';
//
// class RootGuard extends ConsumerWidget {
//   const RootGuard({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final isSecureAsync = ref.watch(isDeviceSecureProvider);
//
//     return isSecureAsync.when(
//       loading: () => const MaterialApp(
//         home: Scaffold(body: Center(child: CircularProgressIndicator())),
//       ),
//       error: (err, stack) => MaterialApp(
//         home: Scaffold(body: Center(child: Text("Error checking device status"))),
//       ),
//         data: (isSecure) {
//           if (isSecure) {
//             return const MyApp();
//           } else {
//             print('❌ Device is NOT secure. Showing BlockedApp screen.');
//             return const BlockedApp();
//           }
//         }
//     );
//   }
// }
