import '../../views.dart';
import 'package:growk_v2/core/constants/common_enums.dart';

class GrowkPhoneField extends ConsumerWidget {
  final TextEditingController controller;

  const GrowkPhoneField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final texts = ref.watch(appTextsProvider);
    final validationError = ref.watch(phoneValidationProvider);

    // Map enum to localized error text dynamically
    String? errorText;
    switch (validationError) {
      case PhoneValidationError.required:
        errorText = texts.mobileNumberRequired;
        break;
      case PhoneValidationError.invalid:
        errorText = texts.invalidMobileNumber;
        break;
      case PhoneValidationError.apiError:
        errorText = texts.invalidMobileNumber; // adjust if you have this
        break;
      default:
        errorText = null;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: texts.enterYourMobileNumber,
          style: AppTextStyle(textColor: AppColors.current(isDark).text).titleSmallMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: AppInputFormatters.saudiPhoneNumber(),
          style: AppTextStyle(textColor: AppColors.current(isDark).text).titleRegular,
          onChanged: (value) {
            ref.read(phoneInputProvider.notifier).state = value;

            // Clear error if user starts editing
            if (ref.read(phoneValidationProvider) != PhoneValidationError.none) {
              ref.read(phoneValidationProvider.notifier).state = PhoneValidationError.none;
            }
          },
          decoration: InputDecoration(
            hintText: texts.mobileNumberHint,
            hintStyle: AppTextStyle(textColor: AppColors.current(isDark).labelText).labelRegular,
            prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    AppImages.saudiFlag,
                    width: 24,
                    height: 16,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '+966',
                    style: AppTextStyle(textColor: AppColors.current(isDark).text).titleRegular,
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.current(isDark).dividerColor, width: 1.5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.current(isDark).dividerColor, width: 1.5),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.current(isDark).text, width: 2),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }
}
