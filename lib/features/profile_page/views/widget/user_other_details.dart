import 'package:growk_v2/core/constants/app_space.dart';
import 'package:growk_v2/features/profile_page/views/widget/bank_details.dart';
import 'package:growk_v2/features/profile_page/views/widget/kyc_details.dart';
import 'package:growk_v2/features/profile_page/views/widget/nominee_details.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_format_fns.dart';
import 'package:growk_v2/features/profile_page/views/widget/profile_info_item.dart';
import 'package:growk_v2/features/profile_page/views/widget/saved_address.dart';
import 'package:growk_v2/views.dart';

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
    final texts = ref.watch(appTextsProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileDetailItem(
            label: texts.gender,
            value: profileFormatGender(userData?.gender, ref),
            isSuffixIconNeeded: false,
          ),
          GapSpace.height30,
          ProfileDetailItem(
            label: texts.dateOfBirth,
            value: profileFormatDate(userData?.dob),
            isSuffixIconNeeded: false,
          ),
          GapSpace.height20,
          kycDetails(ref: ref, context: context),
          GapSpace.height20,
          nomineeDetails(ref: ref, context: context),
          GapSpace.height20,
          savedAddress(ref: ref, context: context),
          GapSpace.height10,
          bankDetails(ref: ref, context: context)
        ],
      ),
    );
  }
}
