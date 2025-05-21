import '../../../../views.dart';

class KycVerificationForm extends ConsumerWidget {
  const KycVerificationForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idController = ref.watch(kycIdControllerProvider);
    final idError = ref.watch(kycIdErrorProvider);
    return ReusableColumn(
      children: <Widget>[
        // ReusableTextField(
        //   inputFormatters: AppInputFormatters.nameFormatter(),
        //   isMandatory: true,
        //   label: 'Name on ID',
        //   hintText: 'Enter full name as per ID',
        //   controller: nameController,
        //   errorText: nameError,
        // ),
        ReusableTextField(
          keyboardType: TextInputType.numberWithOptions(),
          inputFormatters: AppInputFormatters.saudiNationalId(),
          isMandatory: true,
          label: 'National ID/Iqama Number',
          hintText: 'Enter your National ID or Iqama number',
          controller: idController,
          errorText: idError,
        ),
        // GrowkBottomSheetNavigator(
        //   isMandatory: true,
        //   errorText: dobError,
        //   label: 'Date of Birth',
        //   valueText: dob != null
        //       ? '${dob.day.toString().padLeft(2, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.year}'
        //       : 'Select your date of birth',
        //   onTap: () async {
        //     final picked = await showDatePicker(
        //       context: context,
        //       initialDate: DateTime(2000),
        //       firstDate: DateTime(1900),
        //       lastDate: DateTime.now(),
        //     );
        //     if (picked != null) {
        //       ref.read(kycDobProvider.notifier).state = picked;
        //     }
        //   },
        // ),
      ],
    );
  }
}
