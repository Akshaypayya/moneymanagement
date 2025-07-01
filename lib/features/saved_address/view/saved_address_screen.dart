import 'package:growk_v2/features/saved_address/controller/saved_address_controller.dart';
import 'package:growk_v2/features/saved_address/view/widgets/saved_address_save_button.dart';
import 'package:growk_v2/core/widgets/common_title_and_description.dart';
import 'package:growk_v2/views.dart';
class SavedAddressScreen extends ConsumerWidget {
  const SavedAddressScreen({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isDark = ref.watch(isDarkProvider);
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if(didPop){
          ref.read(savedAddressControllerProvider).clearErrorProviders();
        }
      },
      child: ScalingFactor(
        child: CustomScaffold(
          backgroundColor: AppColors.current(isDark).background,
          appBar: GrowkAppBar(
            title: 'Saved Address',
            isBackBtnNeeded: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ReusableColumn(
              children: [
                CommonTitleAndDescription(
                  title: 'Add Address',
                  description: 'Add or update your address details to ensure accurate records. Make sure the information is correct to avoid any issues or delays in processing.',
                ),
                SavedAddressTextFields(),
              ],
            ),
          ),
          bottomNavigationBar: SavedAddressSaveButton(),
        ),
      ),
    );
  }
}
