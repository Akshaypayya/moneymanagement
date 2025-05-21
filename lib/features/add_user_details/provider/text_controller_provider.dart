import '../../../views.dart';

final nameControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final emailControllerProvider = Provider<TextEditingController>((ref) {
  final controller = TextEditingController();
  ref.onDispose(controller.dispose);
  return controller;
});

final genderProvider = StateProvider<String>((ref) => 'Male');
final dobProvider = StateProvider<String>((ref) => '');
