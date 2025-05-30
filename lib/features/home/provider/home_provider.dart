import 'package:growk_v2/views.dart';

/// Provider for the repository
final getHomeDetailsRepoProvider = Provider<GetHomeDetailsRepo>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return GetHomeDetailsRepo(networkService);
});

/// Provider for the use case
final getHomeDetailsUseCaseProvider = Provider<GetHomeDetailsUseCase>((ref) {
  final repo = ref.watch(getHomeDetailsRepoProvider);
  return GetHomeDetailsUseCase(repo);
});

/// FutureProvider to fetch data asynchronously
final getHomeDetailsProvider = FutureProvider<GetHomeDetailsModel>((ref) async {
  final useCase = ref.watch(getHomeDetailsUseCaseProvider);
  return await useCase();
});
/// Provider for the HomeController
final homeControllerProvider = Provider<HomeController>((ref) {
  final useCase = ref.watch(getHomeDetailsUseCaseProvider);
  return HomeController(useCase);
});

/// FutureProvider to expose fetched home details to the UI
final homeDetailsProvider = FutureProvider<GetHomeDetailsModel>((ref) async {
  final controller = ref.watch(homeControllerProvider);
  return await controller.fetchHomeDetails();
});

final totalSavingsProvider = Provider<String?>((ref) {
  final asyncHome = ref.watch(homeDetailsProvider);
  return asyncHome.whenOrNull(data: (data) => data.data?.totalBalance?.toStringAsFixed(2));
});

final goldWeightProvider = Provider<String?>((ref) {
  final asyncHome = ref.watch(homeDetailsProvider);
  return asyncHome.whenOrNull(data: (data) => data.data?.goldBalance?.toStringAsFixed(3));
});
final walletBalanceProvider = Provider<String?>((ref) {
  final asyncHome = ref.watch(homeDetailsProvider);
  return asyncHome.whenOrNull(data: (data) => data.data?.walletBalance?.toStringAsFixed(3));
});
final appColorsProvider = Provider<AppColors>((ref) {
  final isDark = ref.watch(isDarkProvider);
  return AppColors.current(isDark);
});
