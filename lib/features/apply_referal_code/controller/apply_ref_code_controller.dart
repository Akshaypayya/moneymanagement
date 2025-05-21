import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/apply_referal_code/provider/ref_code_provider.dart';
import 'package:money_mangmnt/features/apply_referal_code/use_case/apply_ref_code_use_case.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';
import '../repo/apply_ref_code_repo.dart';

class ApplyRefCodeController {
  final Ref ref;

  ApplyRefCodeController(this.ref);

  Future<bool> submit(BuildContext context) async {
    final referralCode = ref.read(referralCodeProvider).trim();

    if (referralCode.isEmpty) {
      ref.read(referralValidationProvider.notifier).state =
          "Referral code is required";
      return false;
    }

    ref.read(referralValidationProvider.notifier).state = null;
    ref.read(isSubmittingProvider.notifier).state = true;

    try {
      final network = ref.read(networkServiceProvider);
      final repo = ApplyRefCodeRepo(network);
      final useCase = ApplyRefCodeUseCase(repo);

      final result = await useCase(referralCode);

      if (result.status?.toLowerCase() == 'success') {
        return true;
      } else {
        ref.read(referralValidationProvider.notifier).state =
            result.message ?? "Invalid referral code";
        return false;
      }
    } catch (e) {
      ref.read(referralValidationProvider.notifier).state =
          "Something went wrong. Please try again.";
      return false;
    } finally {
      ref.read(isSubmittingProvider.notifier).state = false;
    }
  }
}
