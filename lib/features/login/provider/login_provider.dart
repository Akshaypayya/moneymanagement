import 'package:growk_v2/core/constants/app_url.dart';
import 'package:growk_v2/core/network/network_service.dart';
import 'package:growk_v2/features/login/controller/login_controller.dart';
import 'package:growk_v2/features/login/repo/login_repo.dart';
import 'package:growk_v2/features/login/use_case/login_use_case.dart';
import 'package:growk_v2/views.dart';

final httpClientProvider = Provider((ref) => createUnsafeClient());

final loginNetworkProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: ref.watch(httpClientProvider),
    baseUrl: AppUrl.baseUrl,
  );
});


final loginRepoProvider = Provider(
  (ref) => LoginRepository(ref.watch(loginNetworkProvider)),
);

final loginUseCaseProvider = Provider(
  (ref) => LoginUseCase(ref.watch(loginRepoProvider)),
);

final cellNoControllerProvider =
    Provider.autoDispose<TextEditingController>((ref) {
  final controller = TextEditingController();

  controller.addListener(() {
    ref.read(phoneInputProvider.notifier).state = controller.text;
  });

  ref.onDispose(() => controller.dispose());
  return controller;
});

final loginControllerProvider = Provider<LoginController>((ref) {
  return LoginController(ref);
});
