import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:money_mangmnt/features/bank_details/repo/bank_otp_repo.dart';
import 'package:money_mangmnt/features/profile_page/provider/user_details_provider.dart';

// Assumes you have a NetworkService instance provided as `networkServiceProvider`
final bankOtpRepoProvider = Provider<BankOtpRepo>(
  (ref) => BankOtpRepo(ref.read(networkServiceProvider)),
);
final otpErrorProvider = StateProvider<String?>((ref) => null);
