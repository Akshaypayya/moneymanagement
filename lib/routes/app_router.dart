import 'package:growk_v2/core/biometric/biometric_page.dart';
import 'package:growk_v2/features/add_user_details/view/edit_user_details.dart';
import 'package:growk_v2/features/bank_details/views/bank_details_screen.dart';
import 'package:growk_v2/features/goals/add_goal_page/view/add_goal_page.dart';
import 'package:growk_v2/features/goals/edit_goal_page/view/edit_goal_page.dart';
import 'package:growk_v2/features/gold_price_trends/view/gold_price_trends_page.dart';
import 'package:growk_v2/features/kyc_verification/views/kyc_verification_page.dart';
import 'package:growk_v2/features/nominee_details/views/nominee_details_screen.dart';
import 'package:growk_v2/features/notifcation_page/notification_page.dart';
import 'package:growk_v2/features/referral_rewards/view/referral_rewards_screen.dart';
import 'package:growk_v2/features/saved_address/view/saved_address_screen.dart';
import 'package:growk_v2/features/settings_page/widgets/help_screen.dart';
import 'package:growk_v2/features/settings_page/widgets/terms_and_condition.dart';
import 'package:growk_v2/features/wallet_page/wallet_page.dart';
import 'package:growk_v2/views.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String otpScreen = '/otpScreen';
  static const String mainScreen = '/mainScreen';
  static const String buyGoldInstantly = '/buyGoldInstantly';
  static const String applyReferralCode = '/applyReferralCode';
  static const String buyGoldSummary = '/buyGoldSummary';
  static const String referralRewards = '/referralRewards';
  static const String goldPriceTrends = '/goldPriceTrends';
  static const String notificationScreen = '/notificationScreen';
  static const String walletPage = '/walletPage';
  static const String editUserDetailsScreen = '/editUserDetailsScreen';
  static const String savedAddressScreen = '/savedAddressScreen';
  static const String kycVerificationScreen = '/kycVerificationScreen';
  static const String nomineeDetailsScreen = '/nomineeDetailsScreen';
  static const String bankDetailsScreen = '/bankDetailsScreen';
  static const String createGoalScreen = '/createGoalScreen';
  static const String editGoalPage = '/editGoalPage';
  static const String addGoalPage = '/addGoalPage';
  static const String biometricAuth = '/biometricAuth';
  static const String termsAndConditions = '/termsAndConditions';
  static const String help = '/help';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
            builder: (_) => const SplashScreen(), settings: RouteSettings());
      case login:
        return MaterialPageRoute(
            builder: (_) => const LoginScreen(), settings: RouteSettings());
      case otpScreen:
        return MaterialPageRoute(
            builder: (_) => const OtpScreen(), settings: RouteSettings());
      case mainScreen:
        return MaterialPageRoute(
            builder: (_) => const MainScreen(), settings: RouteSettings());
      case buyGoldInstantly:
        return MaterialPageRoute(
            builder: (_) => const BuyGoldPage(), settings: RouteSettings());
      case applyReferralCode:
        return MaterialPageRoute(
            builder: (_) => const ApplyReferalCodeScreen(),
            settings: RouteSettings());
      case buyGoldSummary:
        return MaterialPageRoute(
            builder: (_) => const BuyGoldSummaryPage(),
            settings: RouteSettings());
      case referralRewards:
        return MaterialPageRoute(
            builder: (_) => const ReferralRewardsPage(),
            settings: RouteSettings());
      case goldPriceTrends:
        return MaterialPageRoute(
            builder: (_) => const GoldPriceTrendsPage(),
            settings: RouteSettings());
      case notificationScreen:
        return MaterialPageRoute(
            builder: (_) => const NotificationsPage(),
            settings: RouteSettings());
      case walletPage:
        return MaterialPageRoute(
            builder: (_) => const WalletPage(), settings: RouteSettings());
      case editUserDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => const EditUserDetails(), settings: RouteSettings());
      case savedAddressScreen:
        return MaterialPageRoute(
            builder: (_) => const SavedAddressScreen(),
            settings: RouteSettings());
      case kycVerificationScreen:
        return MaterialPageRoute(
            builder: (_) => const KycVerificationPage(),
            settings: RouteSettings());
      case nomineeDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => const NomineeDetailsScreen(),
            settings: RouteSettings());
      case bankDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => const BankDetailsScreen(),
            settings: RouteSettings());
      case createGoalScreen:
        return MaterialPageRoute(
            builder: (_) => const CreateGoalPage(), settings: RouteSettings());
      case editGoalPage:
        return MaterialPageRoute(
            builder: (_) => const EditGoalPage(), settings: RouteSettings());
      case addGoalPage:
        return MaterialPageRoute(
            builder: (_) => const CreateGoalPage(), settings: RouteSettings());
      case biometricAuth:
        return MaterialPageRoute(
            builder: (_) => const BiometricAuthPage(), settings: settings);
      case termsAndConditions:
        return MaterialPageRoute(
            builder: (_) => const TermsWebView(), settings: settings);
      case help:
        return MaterialPageRoute(
            builder: (_) => const HelpScreenWeb(), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
          ),
        );


    }
  }
}
