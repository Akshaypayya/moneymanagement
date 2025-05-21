import 'package:money_mangmnt/views.dart';

class NomineeDetailsButton extends ConsumerWidget {
  const NomineeDetailsButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(nomineeDetailsControllerProvider);

    return ReusableSizedBox(
      height: 150,
      child: GrowkButton(
        title: 'Save',
        onTap: () {
          controller.submitNomineeDetails(context, ref);
        },
      ),
    );
  }
}
