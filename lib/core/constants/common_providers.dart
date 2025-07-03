import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/app_texts_string.dart';

final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));
final appTextsProvider = StateProvider<AppTextsString>((ref) {
  return AppTextsString.empty();
});

