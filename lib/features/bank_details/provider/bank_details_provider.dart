import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/bank_details/repo/bank_repo.dart';
import 'package:money_mangmnt/features/bank_details/repo/update_bank_details_repo.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';

/// ✅ Persistent controllers (no autoDispose)
final bankNameControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final bankIbanControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});
final isBankOtpSubmittingProvider = StateProvider<bool>((ref) => false);
final bankReIbanControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// ✅ Error state providers
final bankNameErrorProvider = StateProvider<String?>((ref) => null);
final bankIbanErrorProvider = StateProvider<String?>((ref) => null);
final bankReIbanErrorProvider = StateProvider<String?>((ref) => null);

/// ✅ Repositories
final bankRepoProvider = Provider<BankRepository>((ref) {
  final network = ref.watch(networkServiceProvider);
  return BankRepository(network);
});

final updateBankRepoProvider = Provider<UpdateBankRepository>((ref) {
  final network = ref.watch(networkServiceProvider);
  return UpdateBankRepository(network);
});
final isBankDetailsSubmittingProvider = StateProvider<bool>((ref) => false);
