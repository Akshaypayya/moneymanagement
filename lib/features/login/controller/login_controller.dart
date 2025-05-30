import 'package:growk_v2/views.dart';

class LoginController {
  final Ref ref;

  LoginController(this.ref);

  Future<void> validatePhone(BuildContext context) async {
    final text = ref.read(cellNoControllerProvider).text.trim();

    if (text.isEmpty) {
      ref.read(phoneValidationProvider.notifier).state =
          'Mobile number is required';
      return;
    }

    if (text.length != 9 || !text.startsWith('5')) {
      ref.read(phoneValidationProvider.notifier).state =
          'Invalid mobile number';
      return;
    }

    ref.read(phoneValidationProvider.notifier).state = null;
    ref.read(phoneInputProvider.notifier).state = text;
    ref.read(isButtonLoadingProvider.notifier).state = true;

    try {
      final response = await ref.read(loginUseCaseProvider).call(text);

      if (response.isValidationFailed) {
        final error = response.data?['cellNo'] ?? response.message;
        ref.read(phoneValidationProvider.notifier).state = error;
        debugPrint('Validation Error: $error');
      } else if (response.isSuccess) {
        debugPrint('Login Success: ${response.message}');
        Navigator.pushNamed(context, AppRouter.otpScreen);
      } else {
        debugPrint('Login Failed: ${response.message}');
      }
    } catch (e) {
      debugPrint('Login Exception: $e');
    } finally {
      ref.read(isButtonLoadingProvider.notifier).state = false;
    }
  }
}
