// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:growk_v2/core/network/network_service.dart';
// import 'package:growk_v2/core/constants/app_url.dart';
// import 'package:growk_v2/features/goals/add_goal_page/controller/create_goal_controller.dart';
// import 'package:growk_v2/features/goals/add_goal_page/repo/create_goal_repo.dart';
// import 'package:image_picker/image_picker.dart';

// final goalNameProvider = StateProvider<String>((ref) => '');
// final selectedGoalIconProvider = StateProvider<String>((ref) => 'home.png');
// final selectedImageFileProvider = StateProvider<XFile?>((ref) => null);
// final yearSliderProvider = StateProvider<double>((ref) => 0.12);
// final amountSliderProvider = StateProvider<double>((ref) => 0.65);
// final frequencyProvider = StateProvider<String>((ref) => 'Monthly');
// final autoDepositProvider = StateProvider<bool>((ref) => false);

// final calculatedAmountProvider = Provider<double>((ref) {
//   final sliderValue = ref.watch(amountSliderProvider);

//   final minAmount = 10000.0;
//   final maxAmount = 1000000.0;
//   final stepSize = 10000.0;

//   final rawAmount = minAmount + (sliderValue * (maxAmount - minAmount));

//   final steppedAmount = (rawAmount / stepSize).round() * stepSize;

//   return steppedAmount;
// });

// final calculatedYearProvider = Provider<int>((ref) {
//   final yearValue = ref.watch(yearSliderProvider);
//   return 2025 + (yearValue * 25).round();
// });

// final networkServiceProvider = Provider<NetworkService>((ref) {
//   return NetworkService(
//     client: createUnsafeClient(),
//     baseUrl: AppUrl.baseUrl,
//   );
// });

// final createGoalRepositoryProvider = Provider<CreateGoalRepository>((ref) {
//   final networkService = ref.watch(networkServiceProvider);
//   return CreateGoalRepository(networkService, ref);
// });

// final createGoalControllerProvider = Provider<CreateGoalController>((ref) {
//   return CreateGoalController(ref);
// });

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/core/network/network_service.dart';
import 'package:money_mangmnt/core/constants/app_url.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/controller/create_goal_controller.dart';
import 'package:money_mangmnt/features/goals/add_goal_page/repo/create_goal_repo.dart';
import 'package:image_picker/image_picker.dart';

final goalNameProvider = StateProvider<String>((ref) => '');
final selectedGoalIconProvider = StateProvider<String>((ref) => '');
final selectedImageFileProvider = StateProvider<XFile?>((ref) => null);
final yearSliderProvider = StateProvider<double>((ref) => 0.12);
final amountSliderProvider = StateProvider<double>((ref) => 0.65);
final frequencyProvider = StateProvider<String>((ref) => 'Monthly');
final autoDepositProvider = StateProvider<bool>((ref) => false);

final calculatedAmountProvider = Provider<double>((ref) {
  final sliderValue = ref.watch(amountSliderProvider);
  final minAmount = 10000.0;
  final maxAmount = 1000000.0;
  final stepSize = 10000.0;

  final rawAmount = minAmount + (sliderValue * (maxAmount - minAmount));

  final steps = (rawAmount / stepSize).round();
  final steppedAmount = steps * stepSize;

  return steppedAmount;
});

final calculatedYearProvider = Provider<int>((ref) {
  final yearValue = ref.watch(yearSliderProvider);
  return 2025 + (yearValue * 25).round();
});

final networkServiceProvider = Provider<NetworkService>((ref) {
  return NetworkService(
    client: createUnsafeClient(),
    baseUrl: AppUrl.baseUrl,
  );
});

final createGoalRepositoryProvider = Provider<CreateGoalRepository>((ref) {
  final networkService = ref.watch(networkServiceProvider);
  return CreateGoalRepository(networkService, ref);
});

final createGoalControllerProvider = Provider<CreateGoalController>((ref) {
  return CreateGoalController(ref);
});
