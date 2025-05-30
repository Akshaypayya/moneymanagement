import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/features/saved_address/repo/saved_address_repo.dart';
import 'package:growk_v2/views.dart';

/// ✅ Persistent TextEditingControllers (no autoDispose)
final pinCodeControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final addressLine1ControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final addressLine2ControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final cityControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final stateControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// ✅ Error StateProviders
final pinCodeErrorProvider = StateProvider<String?>((ref) => null);
final addressLine1ErrorProvider = StateProvider<String?>((ref) => null);
final addressLine2ErrorProvider = StateProvider<String?>((ref) => null);
final cityErrorProvider = StateProvider<String?>((ref) => null);
final stateErrorProvider = StateProvider<String?>((ref) => null);

/// ✅ Saved Address Repository Provider
final savedAddressRepoProvider = Provider<SavedAddressRepo>((ref) {
  final network = ref.watch(networkServiceProvider);
  return SavedAddressRepo(network);
});
