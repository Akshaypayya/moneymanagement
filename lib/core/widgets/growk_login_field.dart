import '../../views.dart';

class GrowkPhoneField extends ConsumerWidget {
  final TextEditingController controller;
  final String? errorText;

  const GrowkPhoneField({
    super.key,
    required this.controller,

    this.errorText,
  });

  @override

  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: "Enter your mobile number",
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

            // Optionally clear validation error when typing
            if (ref.read(phoneValidationProvider.notifier).state != null) {
              ref.read(phoneValidationProvider.notifier).state = null;
            }
          },
          decoration: InputDecoration(
            hintText: 'Mobile number',
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
