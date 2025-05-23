import 'package:money_mangmnt/views.dart';
class BankDetailsForm extends ConsumerWidget {
  const BankDetailsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = ref.read(bankNameControllerProvider);
    final ibanController = ref.read(bankIbanControllerProvider);
    final reIbanController = ref.read(bankReIbanControllerProvider);
    final nameError = ref.watch(bankNameErrorProvider);
    final ibanError = ref.watch(bankIbanErrorProvider);
    final reIbanError = ref.watch(bankReIbanErrorProvider);
    print('UI sees: ${nameController.text}');
    debugPrint('💬 nameController.text: ${nameController.text}');
    return ReusableColumn(
      children: <Widget>[
        ReusableTextField(
          isMandatory: true,
          inputFormatters: AppInputFormatters.nameFormatter(),
          label: 'Account Holder Name',
          hintText: 'Enter name on account',
          controller: nameController,
          errorText: nameError,
        ),
        ReusableTextField(
          keyboardType: TextInputType.visiblePassword,
          isMandatory: true,
          inputFormatters: AppInputFormatters.saudiIbanFormatter(),
          label: 'IBAN Number',
          hintText: 'Enter Saudi IBAN (e.g., SA0380000000608010167519)',
          controller: ibanController,
          errorText: ibanError,
        ),
        ReusableTextField(
          keyboardType: TextInputType.visiblePassword,
          isMandatory: true,
          inputFormatters: AppInputFormatters.saudiIbanFormatter(),
          label: 'Re-enter IBAN',
          hintText: 'Re-enter IBAN number for confirmation',
          controller: reIbanController,
          errorText: reIbanError,
        ),
      ],
    );
  }
}
