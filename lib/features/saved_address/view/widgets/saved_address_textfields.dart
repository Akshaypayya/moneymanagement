import 'package:growk_v2/views.dart';

class SavedAddressTextFields extends ConsumerWidget {
  const SavedAddressTextFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final zipCtrl = ref.watch(pinCodeControllerProvider);
    final address1Ctrl = ref.watch(addressLine1ControllerProvider);
    final address2Ctrl = ref.watch(addressLine2ControllerProvider);
    final cityCtrl = ref.watch(cityControllerProvider);
    final stateCtrl = ref.watch(stateControllerProvider);

    final zipError = ref.watch(pinCodeErrorProvider);
    final address1Error = ref.watch(addressLine1ErrorProvider);
    final address2Error = ref.watch(addressLine2ErrorProvider);
    final cityError = ref.watch(cityErrorProvider);
    final stateError = ref.watch(stateErrorProvider);

    return ScalingFactor(
      child: ReusableColumn(children: <Widget>[
        const ReusableSizedBox(height: 20),
        ReusableTextField(
          isMandatory: true,
          label: 'Address Line 1',
          hintText: 'Enter house number, building, etc.',
          inputFormatters: AppInputFormatters.addressFormatter(),
          controller: address1Ctrl,
          errorText: address1Error,
        ),
        ReusableTextField(
          isMandatory: true,
          errorText: address2Error,
          label: 'Address Line 2',
          hintText: 'Enter street, locality, etc.',
          inputFormatters: AppInputFormatters.addressFormatter(),
          controller: address2Ctrl,
        ),
        ReusableTextField(
          isMandatory: true,
          label: 'City',
          hintText: 'Enter your city',
          inputFormatters: AppInputFormatters.nameFormatter(),
          controller: cityCtrl,
          errorText: cityError,
        ),
        ReusableTextField(
          isMandatory: true,
          label: 'State',
          hintText: 'Enter your state',
          inputFormatters: AppInputFormatters.nameFormatter(),
          controller: stateCtrl,
          errorText: stateError,
        ),
        ReusableTextField(
          isMandatory: true,
          label: 'Pin Code',
          hintText: 'Enter your area pin code',
          inputFormatters: AppInputFormatters.saudiZipCode(),
          controller: zipCtrl,
          errorText: zipError,
        ),
      ]),
    );
  }
}
