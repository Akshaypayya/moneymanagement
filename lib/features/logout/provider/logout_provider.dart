import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/login/provider/login_provider.dart';
import 'package:growk_v2/features/logout/controller/logout_controller.dart';
import 'package:growk_v2/features/logout/repo/logout_repo.dart';
import '../../../core/network/network_service.dart';

final logoutNetworkProvider = Provider<NetworkService>((ref) {
  return ref.watch(loginNetworkProvider);
});

final logoutRepoProvider = Provider(
  (ref) => LogoutRepository(ref.watch(logoutNetworkProvider)),
);

final isLogoutLoadingProvider = StateProvider<bool>((ref) => false);

final logoutControllerProvider = Provider<LogoutController>((ref) {
  return LogoutController(ref);
});
