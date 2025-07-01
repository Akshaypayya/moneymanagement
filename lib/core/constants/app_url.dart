class AppUrl {
  static const String baseUrl = 'https://202.88.237.252:8804/gateway-service';
  static const String loginUrl = '/token-service/user/signIn';
  static const String otpUrl = '/token-service/authentication/tokenRequest';
  static const String logoutUrl = '/token-service/authentication/logout';
  static const String uploadProPicUrl =
      '/user-service/user/uploadProfilePicture';
  static const String getUserDetailsUrl = '/user-service/user/getUserDetails';
  static const String updateUserDetailsUrl = '/user-service/user/updateUser';
  static const String getHomeDetails =
      '/user-service/user/getHomeScreenDetails';
  static const String saveBankDetailsUrl = "/user-service/user/saveAccDetails";
  static const String updateBankDetailsUrl =
      "/user-service/user/updateAccDetails";
  static const String bankOtp = "/user-service/user/verifyBankAccOtp";
  static const String nomineeDetailsUrl = "/user-service/user/setNominee";
  static const String savedAddressUrl = "/user-service/user/savedAddress";
  static const String createGoalUrl = "/user-service/goals";

  static String goalViewByNameUrl(String goalName) {
    final encodedName = goalName.replaceAll(' ', '+');
    return '/user-service/goals?goalName=$encodedName';
  }

  static String goalTransactionByNameUrl(
      String goalName, String iDisplayStart, String iDisplayLength) {
    final encodedName = goalName.replaceAll(' ', '+');
    return '/user-service/goals/getAllTransaction?iDisplayStart=$iDisplayStart&iDisplayLength=$iDisplayLength&goalName=$encodedName';
  }

  static String transactionPaginationUrl(
      int iDisplayStart, int iDisplayLength) {
    return '/user-service/goals/getAllTransaction?iDisplayStart=$iDisplayStart&iDisplayLength=$iDisplayLength';
  }

  static const String goalListUrl = "/user-service/goals";
  static const String applyRefCodeUrl = "/user-service/user/referralCode/apply";
  static const String updateGoalUrl = "/user-service/goals";
  static const String getRefferalHistoryUrl =
      "/user-service/user/referralHistory";
  static const String loadAmountToWallet = "/user-service/user/loadAmount";
  static const String getWalletBalance = "/user-service/user/getWalletBalance";
  static const String getAllTransactionUrl =
      "/user-service/goals/getAllTransaction";
  static const String transferAmountUrl = "/user-service/goals/transferAmount";
  static const String initiateGoldBuyUrl =
      "/user-service/user/initiateGoldTransaction";
  static const String buyGoldUrl = "/user-service/user/buyGold";
  static const String addFcmTokenUrl = "/user-service/user/updateFcmToken";
  static const String deleteFcmTokenUrl = "/user-service/user/deleteFcmToken";
  static const String getLiveGoldPriceUrl =
      "/user-service/user/currentGoldRate";
  static const String goalSellGoldUrl = "/user-service/goals/sellGold";
  static const String sellGoldUrl = "/user-service/user/sellGold";
  static const String getGoldHistoryUrl = "/user-service/user/goldRateHistory?currencyCode=SAR&duration=";

  static const String intitiateGoalSellTransactionUrl =
      "/user-service/user/initiateGoldTransaction";
  static String getNotificationListUrl(int iDisplayStart, int iDisplayLength) {
    return '/user-service/user/getNotificationList?iDisplayStart=$iDisplayStart&iDisplayLength=$iDisplayLength';
  }
}
