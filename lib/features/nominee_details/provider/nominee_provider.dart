import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/nominee_details/controller/nominee_controller.dart';
import 'package:money_mangmnt/features/nominee_details/repo/nominee_repo.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart'; // Adjust if needed

// TextEditingController for nominee name
final nomineeNameControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

// Error Providers
final nomineeNameErrorProvider = StateProvider<String?>((ref) => null);
final nomineeDobErrorProvider = StateProvider<String?>((ref) => null);
final nomineeRelationErrorProvider = StateProvider<String?>((ref) => null);

// StateProviders for bottom sheet controlled fields
final nomineeDobProvider = StateProvider<String>((ref) => '');
final nomineeDobUIProvider = StateProvider<String>((ref) => ''); // For UI
final nomineeRelationProvider =
    StateProvider<String>((ref) => 'Father'); // ✅ Default set

final nomineeDetailsControllerProvider =
    Provider.autoDispose<NomineeDetailsController>(
  (ref) => NomineeDetailsController(ref),
);

final nomineeRepoProvider = Provider<NomineeRepo>((ref) {
  final network = ref.watch(networkServiceProvider);
  return NomineeRepo(network);
});
