import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:growk_v2/core/constants/common_enums.dart';

final phoneValidationProvider = StateProvider<PhoneValidationError>((ref) => PhoneValidationError.none);
final phoneInputProvider = StateProvider<String>((ref) => '');
