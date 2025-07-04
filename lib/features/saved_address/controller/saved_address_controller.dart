import 'package:growk_v2/features/saved_address/model/saved_adddress_model.dart';
import '../../../views.dart';

class SavedAddressController {
  final Ref ref;

  SavedAddressController(this.ref);

  bool validate() {
    bool isValid = true;

    final pin = ref.read(pinCodeControllerProvider).text.trim();
    final line1 = ref.read(addressLine1ControllerProvider).text.trim();
    final line2 = ref.read(addressLine2ControllerProvider).text.trim();
    final city = ref.read(cityControllerProvider).text.trim();
    final state = ref.read(stateControllerProvider).text.trim();

    // Pin code validation
    if (pin.isEmpty) {
      ref.read(pinCodeErrorProvider.notifier).state = 'Pin code is required';
      isValid = false;
    } else if (pin.length != 5 || int.tryParse(pin) == null) {
      ref.read(pinCodeErrorProvider.notifier).state = 'Enter a valid 5-digit pin code';
      isValid = false;
    } else {
      ref.read(pinCodeErrorProvider.notifier).state = null;
    }

    // Address Line 1 validation
    if (line1.isEmpty) {
      ref.read(addressLine1ErrorProvider.notifier).state = 'Address Line 1 is required';
      isValid = false;
    } else if (line1.length < 3 || line1.length > 70) {
      ref.read(addressLine1ErrorProvider.notifier).state = 'Address length must be between 3 and 70';
      isValid = false;
    } else {
      ref.read(addressLine1ErrorProvider.notifier).state = null;
    }

    // Address Line 2 validation
    if (line2.isEmpty) {
      ref.read(addressLine2ErrorProvider.notifier).state = 'Address Line 2 is required';
      isValid = false;
    } else if (line2.length < 3 || line2.length > 70) {
      ref.read(addressLine2ErrorProvider.notifier).state = 'Address length must be between 3 and 70';
      isValid = false;
    } else {
      ref.read(addressLine2ErrorProvider.notifier).state = null;
    }

    // City validation
    if (city.isEmpty) {
      ref.read(cityErrorProvider.notifier).state = 'City is required';
      isValid = false;
    } else if (city.length < 3 || city.length > 50) {
      ref.read(cityErrorProvider.notifier).state = 'City length must be between 3 and 50';
      isValid = false;
    } else {
      ref.read(cityErrorProvider.notifier).state = null;
    }

    // State validation
    if (state.isEmpty) {
      ref.read(stateErrorProvider.notifier).state = 'State is required';
      isValid = false;
    } else if (state.length < 3 || state.length > 50) {
      ref.read(stateErrorProvider.notifier).state = 'State length must be between 3 and 50';
      isValid = false;
    } else {
      ref.read(stateErrorProvider.notifier).state = null;
    }

    return isValid;
  }
  void clearErrorProviders() {
    ref.read(pinCodeErrorProvider.notifier).state = null;
    ref.read(addressLine1ErrorProvider.notifier).state = null;
    ref.read(addressLine2ErrorProvider.notifier).state = null;
    ref.read(cityErrorProvider.notifier).state = null;
    ref.read(stateErrorProvider.notifier).state = null;
  }

  void clearFields() {
    ref.read(pinCodeControllerProvider).clear();
    ref.read(addressLine1ControllerProvider).clear();
    ref.read(addressLine2ControllerProvider).clear();
    ref.read(cityControllerProvider).clear();
    ref.read(stateControllerProvider).clear();

    ref
        .read(pinCodeErrorProvider.notifier)
        .state = null;
    ref
        .read(addressLine1ErrorProvider.notifier)
        .state = null;
    ref
        .read(addressLine2ErrorProvider.notifier)
        .state = null;
    ref
        .read(cityErrorProvider.notifier)
        .state = null;
    ref
        .read(stateErrorProvider.notifier)
        .state = null;
  }


  Future<SavedAdddressModel?> submit() async {
    final useCase = SavedAddressUseCase(ref.read(savedAddressRepoProvider));

    final pin = ref
        .read(pinCodeControllerProvider)
        .text
        .trim();
    final line1 = ref
        .read(addressLine1ControllerProvider)
        .text
        .trim();
    final line2 = ref
        .read(addressLine2ControllerProvider)
        .text
        .trim();
    final city = ref
        .read(cityControllerProvider)
        .text
        .trim();
    final state = ref
        .read(stateControllerProvider)
        .text
        .trim();

    // 🖨️ Print controller values for debugging
    print('📦 Pincode: $pin');
    print('📦 Address Line 1: $line1');
    print('📦 Address Line 2: $line2');
    print('📦 City: $city');
    print('📦 State: $state');

    final data = {
      'pinCode': pin,
      'streetAddress1': line1,
      'streetAddress2': line2,
      'city': city,
      'state': state,
    };

    return await useCase.call(data);
  }
}
  final savedAddressControllerProvider =
Provider.autoDispose<SavedAddressController>((ref) {
  return SavedAddressController(ref);
});
