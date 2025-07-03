import 'package:growk_v2/views.dart';
import 'package:growk_v2/core/constants/common_enums.dart';

class LoginController {
  final Ref ref;

  LoginController(this.ref);
  void toggleLanguage() {
    final currentLocale = ref.read(localeProvider);

    if (currentLocale.languageCode == 'en') {
      ref.read(localeProvider.notifier).state = const Locale('ar');
    } else {
      ref.read(localeProvider.notifier).state = const Locale('en');
    }
  }
  Future<void> validatePhone(BuildContext context) async {
    final text = ref.read(cellNoControllerProvider).text.trim();

    if (text.isEmpty) {
      ref.read(phoneValidationProvider.notifier).state = PhoneValidationError.required;
      return;
    }

    if (text.length != 9 || !text.startsWith('5')) {
      ref.read(phoneValidationProvider.notifier).state = PhoneValidationError.invalid;
      return;
    }

    ref.read(phoneValidationProvider.notifier).state = PhoneValidationError.none;
    ref.read(phoneInputProvider.notifier).state = text;
    ref.read(isButtonLoadingProvider.notifier).state = true;

    try {
      final response = await ref.read(loginUseCaseProvider).call(text);

      if (response.isValidationFailed) {
        debugPrint('Validation Error: ${response.message}');
        ref.read(phoneValidationProvider.notifier).state = PhoneValidationError.apiError;
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
