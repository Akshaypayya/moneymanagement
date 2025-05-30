
import 'package:intl/intl.dart';

import '../../../views.dart';
import 'package:growk_v2/features/nominee_details/use_case/nominee_use_case.dart';
class NomineeDetailsController {
  final Ref ref;

  NomineeDetailsController(this.ref);

  void showDateOfBirthPicker(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final pickedDate = await DatePickerUtils.showThemedDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final formatted = DatePickerUtils.formatDate(pickedDate); // e.g., 'yyyy-MM-dd'
      final uiFormatted = DateFormat('dd/MM/yyyy').format(pickedDate);
      debugPrint('📅 UI DOB format: $uiFormatted');
      debugPrint('🛠 pickedDate raw: $pickedDate');  // Shows full datetime
      debugPrint('🛠 normalizedDate: ${DateTime.utc(pickedDate.year, pickedDate.month, pickedDate.day)}');
      debugPrint('📅 Backend DOB format: $formatted');
      ref.read(nomineeDobProvider.notifier).state = formatted;
      ref.read(nomineeDobUIProvider.notifier).state = uiFormatted;
      ref.read(nomineeDobErrorProvider.notifier).state = null;
    }
  }

  void showRelationSheet(BuildContext context) {
    FocusScope.of(context).unfocus();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommonBottomSheet(
        title: 'Select Relation',
        options: ['Father', 'Mother', 'Spouse', 'Brother', 'Sister', 'Child', 'Other'],
        onSelected: (value) {
          ref.read(nomineeRelationProvider.notifier).state = value;
          ref.read(nomineeRelationErrorProvider.notifier).state = null;
        },
      ),
    );
  }

  void clearFields() {
    ref.read(nomineeNameControllerProvider).clear();
    ref.read(nomineeDobProvider.notifier).state = '';
    ref.read(nomineeDobUIProvider.notifier).state = '';
    ref.read(nomineeRelationProvider.notifier).state = 'Father';

    ref.read(nomineeNameErrorProvider.notifier).state = null;
    ref.read(nomineeDobErrorProvider.notifier).state = null;
    ref.read(nomineeRelationErrorProvider.notifier).state = null;
  }

  bool validate() {
    bool isValid = true;

    final name = ref.read(nomineeNameControllerProvider).text.trim();
    final dob = ref.read(nomineeDobProvider);
    final relation = ref.read(nomineeRelationProvider);

    if (name.isEmpty) {
      ref.read(nomineeNameErrorProvider.notifier).state = 'Name is required';
      isValid = false;
    } else {
      ref.read(nomineeNameErrorProvider.notifier).state = null;
    }

    if (dob.isEmpty) {
      ref.read(nomineeDobErrorProvider.notifier).state = 'Select a valid date';
      isValid = false;
    } else {
      ref.read(nomineeDobErrorProvider.notifier).state = null;
    }

    if (relation.isEmpty) {
      ref.read(nomineeRelationErrorProvider.notifier).state = 'Choose relation';
      isValid = false;
    } else {
      ref.read(nomineeRelationErrorProvider.notifier).state = null;
    }

    return isValid;
  }

  Future<void> submitNomineeDetails(BuildContext context, WidgetRef ref) async {
    if (!validate()) return;

    ref.read(isButtonLoadingProvider.notifier).state = true;

    final data = {
      'nomineeName': ref.read(nomineeNameControllerProvider).text.trim(),
      'nomineeDob': ref.read(nomineeDobProvider),
      'nomineeRelation': ref.read(nomineeRelationProvider),
    };

    final useCase = NomineeUseCase(ref.read(nomineeRepoProvider));

    try {
      final response = await useCase(data);

      if (response.status == 'Success') {
        await ref.read(userProfileControllerProvider).refreshUserProfile(ref);
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Nominee details submitted successfully!',
          type: SnackType.success,
        );
        Navigator.of(context).pop();
      } else if (response.status == 'ValidationFailed') {
        response.data.forEach((key, value) {
          if (key == 'nomineeName') {
            ref.read(nomineeNameErrorProvider.notifier).state = value;
          } else if (key == 'nomineeDob') {
            ref.read(nomineeDobErrorProvider.notifier).state = value;
          } else if (key == 'nomineeRelation') {
            ref.read(nomineeRelationErrorProvider.notifier).state = value;
          }
        });
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Please correct the highlighted errors.',
          type: SnackType.error,
        );
      } else if (response.status == 'Unauthorized' || response.message?.contains('401') == true) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Session expired. Please log in again.',
          type: SnackType.error,
        );
        // Optional: Navigate to login screen
        // Navigator.pushReplacementNamed(context, AppRouter.login);
      } else {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: response.message ?? 'Failed to submit nominee details.',
          type: SnackType.error,
        );
      }
    } catch (e) {
      debugPrint('🚨 Error submitting nominee details: $e');
      if (e.toString().contains('401')) {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'Session expired. Please log in again.',
          type: SnackType.error,
        );
      } else {
        showGrowkSnackBar(
          context: context,
          ref: ref,
          message: 'An unexpected error occurred. Please try again.',
          type: SnackType.error,
        );
      }
    } finally {
      ref.read(isButtonLoadingProvider.notifier).state = false;
    }
  }
}
