
import 'package:growk_v2/features/saved_address/controller/saved_address_controller.dart';
import '../../../../views.dart';

class SavedAddressSaveButton extends ConsumerWidget {
  const SavedAddressSaveButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(savedAddressControllerProvider);

    return SizedBox(
      width: double.infinity,
      height: 150,
      child: GrowkButton(
        title: 'Save',
        onTap: ref.watch(isButtonLoadingProvider)
            ? null
            : () async {
          final isValid = controller.validate();
          if (!isValid) return;

          ref.read(isButtonLoadingProvider.notifier).state = true;

          final response = await controller.submit();

          ref.read(isButtonLoadingProvider.notifier).state = false;

          if (response != null && response.status == 'Success') {
            await ref.read(userProfileControllerProvider).refreshUserProfile(ref);
            showGrowkSnackBar(
              context: context,
              ref: ref,
              message: 'Address saved successfully!',
              type: SnackType.success,
            );
            Navigator.of(context).pop(); // Close dialog/screen on success
          } else {
            showGrowkSnackBar(
              context: context,
              ref: ref,
              message: response?.message ?? 'Failed to save address.',
              type: SnackType.error,
            );
          }
        },
      ),
    );
  }
}
