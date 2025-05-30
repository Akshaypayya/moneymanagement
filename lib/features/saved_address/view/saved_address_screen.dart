import 'package:growk_v2/features/saved_address/view/widgets/saved_address_save_button.dart';
import 'package:growk_v2/core/widgets/common_title_and_description.dart';
import 'package:growk_v2/views.dart';
class SavedAddressScreen extends StatelessWidget {
  const SavedAddressScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: CustomScaffold(
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
    );
  }
}
