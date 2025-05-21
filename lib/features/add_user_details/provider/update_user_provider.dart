import '../../../views.dart';

final updateUserDetailsProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: ref.watch(httpClientProvider),
    baseUrl: AppUrl.baseUrl,
  );
});
final updateUserDetailsRepoProvider = Provider(
      (ref) => UpdateUserDetailsRepo(ref.watch(updateUserDetailsProvider)),
);

final updateUserDetailsUseCaseProvider = Provider(
      (ref) => UpdateUserUseCase(ref.watch(updateUserDetailsRepoProvider)),
);
final nameErrorProvider = StateProvider<String?>((ref) => null);
final emailErrorProvider = StateProvider<String?>((ref) => null);
final genderErrorProvider = StateProvider<String?>((ref) => null);
final dobErrorProvider = StateProvider<String?>((ref) => null);
final imageErrorProvider = StateProvider<String?>((ref) => null);
