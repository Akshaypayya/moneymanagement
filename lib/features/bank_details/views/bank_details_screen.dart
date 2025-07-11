import 'package:growk_v2/views.dart';
class BankDetailsScreen extends ConsumerWidget {
  const BankDetailsScreen({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          ref.read(bankDetailsControllerProvider.notifier).clearErrorProviders();
        }
      },
      child: ScalingFactor(child: CustomScaffold(
        backgroundColor: AppColors.current(isDark).background,
        appBar: GrowkAppBar(title: 'Bank Details',isBackBtnNeeded: true,),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(left: 22,right: 22),
          child: ReusableColumn(children: <Widget>[
            CommonTitleAndDescription(
              title: 'Add Bank Details',
              description: 'Add or update your bank account information to securely reload your wallet and withdraw money. Ensure the details are correct to avoid transaction failures or delays.',
            ),
            ReusableSizedBox(
              height: 15,
            ),
            BankDetailsForm(),
          ]),
        ),
        bottomNavigationBar: BankDetailsButton(),
      )),
    );
  }
}
