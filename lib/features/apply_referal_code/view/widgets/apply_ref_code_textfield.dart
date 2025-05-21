import '../../../../views.dart';
class ApplyRefCodeTextField extends ConsumerWidget {
  const ApplyRefCodeTextField({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    final errorText = ref.watch(referralValidationProvider);
    final controller = TextEditingController(
      text: ref.read(referralCodeProvider),
    );

    return ScalingFactor(
      child: ReusableColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ReusableText(
            text: "Enter Referral Code",
            style: AppTextStyle(textColor: AppColors.current(isDark).text)
                .titleSmallMedium,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            style: AppTextStyle(textColor: AppColors.current(isDark).text)
                .titleRegular,
            onChanged: (value) {
              ref.read(referralCodeProvider.notifier).state = value;
              if (ref.read(referralValidationProvider.notifier).state != null) {
                ref.read(referralValidationProvider.notifier).state = null;
              }
            },
            decoration: InputDecoration(
              hintText: 'Referral Code',
              hintStyle:
              AppTextStyle(textColor: AppColors.current(isDark).labelText)
                  .labelRegular,
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.current(isDark).dividerColor, width: 1.5),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.current(isDark).dividerColor, width: 1.5),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: AppColors.current(isDark).text, width: 2),
              ),
              errorText: errorText,
            ),
          ),
        ],
      ),
    );
  }
}
