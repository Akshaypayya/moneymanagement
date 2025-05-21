import 'package:money_mangmnt/features/profile_page/model/user_details_model.dart';

import '../../../views.dart';

class UserDetailRepository {
  final NetworkService _networkService;
  final Ref ref;

  UserDetailRepository(this._networkService, this.ref);

  Future<UserDetailsModel> getUserProfile() async {
    try {
      final token = SharedPreferencesHelper.getString("access_token");
      if (token == null || token.isEmpty) {
        debugPrint('API ERROR: Authentication token is missing');
        return UserDetailsModel(
          status: 'failed',
          message: 'Authentication token is missing. Please login again.',
        );
      }

      debugPrint('API REQUEST: GET /user-service/user/getUserDetails');

      final response = await _networkService.get(
        AppUrl.getUserDetailsUrl,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      debugPrint('API RESPONSE: $response');

      if (response != null && response is Map<String, dynamic>) {
        final userProfile = UserDetailsModel.fromJson(response);
        final userDetails = UserProfileModel.fromJson(response);

        if (userProfile.status == "Success") {
          debugPrint('GET USER PROFILE: Successfully retrieved user profile');

          if (userProfile.userData != null) {
            debugPrint('User ID: ${userProfile.userData!.userId}');
            debugPrint('User Name: ${userProfile.userData!.userName}');

            if (userProfile.userData!.profilePicture != null &&
                userProfile.userData!.profilePicture!.isNotEmpty) {
              debugPrint('Profile Picture: Available (Base64)');
            } else {
              debugPrint('Profile Picture: Not available');
            }
          } else {
            debugPrint('User data is null in the response');
            debugPrint('Checking for alternative response structure...');
            debugPrint('Response keys: ${response.keys.toList()}');
          }

          // 👇 Only store if successful
          ref.read(userProfileProvider.notifier).setProfile(userDetails);

// ✅ Bank details
          ref.read(bankNameControllerProvider).text =
              userDetails.bankDetails['nameOnAcc'] ?? '';
          ref.read(bankIbanControllerProvider).text =
              userDetails.bankDetails['accNo'] ?? '';
          ref.read(bankReIbanControllerProvider).text =
              userDetails.bankDetails['accNo'] ?? '';

// ✅ Nominee details
          final nominee = userDetails.nomineeDetails;
          ref.read(nomineeNameControllerProvider).text =
              nominee['nomineeName'] ?? '';
          ref.read(nomineeRelationProvider.notifier).state =
              nominee['nomineeRelation'] ?? 'Father';

          final rawDob = nominee['nomineeDob'];
          if (rawDob != null && rawDob.isNotEmpty) {
            final formattedDob = rawDob.split('T').first;
            ref.read(nomineeDobProvider.notifier).state = formattedDob;
          }

// ✅ Saved Address details
          final address = userDetails.savedAddress;
          ref.read(pinCodeControllerProvider).text = address['pinCode'] ?? '';
          ref.read(addressLine1ControllerProvider).text =
              address['streetAddress1'] ?? '';
          ref.read(addressLine2ControllerProvider).text =
              address['streetAddress2'] ?? '';
          ref.read(cityControllerProvider).text = address['city'] ?? '';
          ref.read(stateControllerProvider).text = address['state'] ?? '';

// ✅ Optional: debug logs
          debugPrint(
              '🏦 Bank Name: ${ref.read(bankNameControllerProvider).text}');
          debugPrint(
              '👤 Nominee Name: ${ref.read(nomineeNameControllerProvider).text}');
          debugPrint(
              '📍 Address City: ${ref.read(cityControllerProvider).text}');

          debugPrint('STORED USER DATA: ${ref.read(userProfileProvider)}');
        } else {
          debugPrint('GET USER PROFILE: Failed to get user profile');
          debugPrint('Error Message: ${userProfile.message}');
        }

        return userProfile;
      } else {
        debugPrint('GET USER PROFILE: Invalid response format');
        debugPrint('Response type: ${response.runtimeType}');
        debugPrint('Response: $response');
        return UserDetailsModel(
          status: 'failed',
          message: 'Invalid response format from server',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('API ERROR: ${e.toString()}');
      debugPrint('STACK TRACE: $stackTrace');
      return UserDetailsModel(
        status: 'failed',
        message: 'Network error: ${e.toString()}',
      );
    }
  }
}
