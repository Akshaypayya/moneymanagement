import 'package:money_mangmnt/features/profile_page/views/widget/profile_info_section.dart';
import 'package:money_mangmnt/views.dart';

Widget bankDetails({required WidgetRef ref, required BuildContext context}) {
  final profileState = ref.watch(userProfileStateProvider);
  final bankData = profileState.bankDetails;
  final userData = profileState.userData;
  return bankData == null
      ? ProfileNavigationItem(
          label: 'Bank Details',
          value1: 'Tap to add Bank Details',
          isValue2Needed: false,
          isValue3Needed: false,
          onTap: userData?.kycVerified == false
              ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please verify your KYC details first')))
              : () => Navigator.pushNamed(context, AppRouter.bankDetailsScreen),
        )
      : ProfileNavigationItem(
          label: 'Bank Details',
          value1: '${bankData.nameOnAcc}, ${bankData.accNo.toString()}',
          value2: '${bankData.ifsc}, ${bankData.nameOnAcc}, ${bankData.status}',
          onTap: userData?.kycVerified == false
              ? () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Please verify your KYC details first')))
              : () => Navigator.pushNamed(context, AppRouter.bankDetailsScreen),
        );
}
