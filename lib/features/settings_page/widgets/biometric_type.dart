import 'package:growk_v2/views.dart';

IconData getIconForBiometricType(List<String> types) {
  if (types.isEmpty) {
    return Icons.fingerprint;
  }

  if (types.any((type) => type.toLowerCase().contains('face'))) {
    return Icons.face;
  } else if (types.any((type) => type.toLowerCase().contains('iris'))) {
    return Icons.remove_red_eye;
  } else {
    return Icons.fingerprint;
  }
}
