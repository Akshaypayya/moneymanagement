import 'package:money_mangmnt/views.dart';

class NomineeDetailsForm extends ConsumerWidget {
  const NomineeDetailsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(nomineeDetailsControllerProvider);

    final nameController = ref.watch(nomineeNameControllerProvider);
    final nameError = ref.watch(nomineeNameErrorProvider) ?? '';
    final dob = ref.watch(nomineeDobProvider);
    final dobError = ref.watch(nomineeDobErrorProvider) ?? '';
    final relation = ref.watch(nomineeRelationProvider);
    final relationError = ref.watch(nomineeRelationErrorProvider) ?? '';
    final dobUI = ref.watch(nomineeDobUIProvider);

    return ReusableColumn(
      children: [
        ReusableTextField(
          inputFormatters: AppInputFormatters.nameFormatter(),
          isMandatory: true,
          label: 'Nominee Name',
          hintText: 'Enter full name',
          controller: nameController,
          errorText: nameError.isEmpty ? null : nameError,
        ),
        GrowkBottomSheetNavigator(
          isMandatory: true,
          label: 'Date of Birth',
          valueText: dobUI.isEmpty ? 'Select date of birth' : dobUI,
          errorText: dobError.isEmpty ? null : dobError,
          onTap: () => controller.showDateOfBirthPicker(context),
          // onClear: () {
          //   ref.read(nomineeDobProvider.notifier).state = '';
          // },
        ),
        GrowkBottomSheetNavigator(
          label: 'Relation',
          valueText: relation.isEmpty ? 'Select relation' : relation,
          errorText: relationError.isEmpty ? null : relationError,
          onTap: () => controller.showRelationSheet(context),
          // onClear: () {
          //   ref.read(nomineeRelationProvider.notifier).state = '';
          // },
        ),
      ],
    );
  }
}
