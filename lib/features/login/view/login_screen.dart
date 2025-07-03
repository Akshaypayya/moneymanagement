import '../../../views.dart';
import 'package:growk_v2/core/constants/common_enums.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(cellNoControllerProvider);
    final validationError = ref.watch(phoneValidationProvider);
    final loginController = ref.read(loginControllerProvider);
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);

    // Dynamically map error enums to localized strings
    String? errorText;
    switch (validationError) {
      case PhoneValidationError.required:
        errorText = texts.mobileNumberRequired;
        break;
      case PhoneValidationError.invalid:
        errorText = texts.invalidMobileNumber;
        break;
      case PhoneValidationError.apiError:
        errorText = texts.invalidMobileNumber;
        break;
      default:
        errorText = null;
    }

    void toggleLanguage() {
      final currentLocale = ref.read(localeProvider);

      if (currentLocale.languageCode == 'en') {
        ref.read(localeProvider.notifier).state = const Locale('ar');
      } else {
        ref.read(localeProvider.notifier).state = const Locale('en');
      }
    }

    return ScalingFactor(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScaffold(
          backgroundColor: AppColors.current(isDark).background,
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ReusableColumn(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const LoginTopIcon(),
                const LoginTopText(),
                GrowkPhoneField(
                  controller: controller,
                ),
                const ReusableSizedBox(height: 250),
                GrowkButton(
                  onTap: () => loginController.validatePhone(context),
                  title: texts.continueText,
                ),
                const LoginBottomText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
