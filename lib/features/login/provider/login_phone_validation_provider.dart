import 'package:flutter_riverpod/flutter_riverpod.dart';

final phoneValidationProvider = StateProvider<String?>((ref) => null);
final phoneInputProvider = StateProvider<String>((ref) => '');
