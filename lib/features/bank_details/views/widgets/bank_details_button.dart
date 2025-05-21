import '../../../../views.dart';

class BankDetailsButton extends ConsumerWidget {
  const BankDetailsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(isBankDetailsSubmittingProvider);

    return ReusableSizedBox(
      height: 150,
      child: GrowkButton(
        title: 'Save',
        onTap: isLoading
            ? null
            : () async {
          final controller = ref.read(bankDetailsControllerProvider.notifier);
          await controller.submitBankDetails(context, ref);
        },
      ),
    );
  }
}
