import 'package:money_mangmnt/features/profile_page/views/widget/bank_details.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/kyc_details.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/nominee_details.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/profile_format_fns.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/profile_info_item.dart';
import 'package:money_mangmnt/features/profile_page/views/widget/saved_address.dart';
import 'package:money_mangmnt/views.dart';

class UserOtherDetails extends ConsumerStatefulWidget {
  const UserOtherDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserOtherDetailsState();
}

class _UserOtherDetailsState extends ConsumerState<UserOtherDetails> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileStateProvider);
    final userData = profileState.userData;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 30,
        children: [
          ProfileDetailItem(
            label: 'Gender',
            value: profileFormatGender(userData?.gender),
            isSuffixIconNeeded: false,
          ),
          ProfileDetailItem(
            label: 'Date of Birth',
            value: profileFormatDate(userData?.dob),
            isSuffixIconNeeded: false,
          ),
          kycDetails(ref: ref, context: context),
          nomineeDetails(ref: ref, context: context),
          savedAddress(ref: ref, context: context),
          bankDetails(ref: ref, context: context)
        ],
      ),
    );
  }
}
