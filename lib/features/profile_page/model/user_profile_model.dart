class UserProfileModel {
  final String gender;
  final String emailId;
  final String userName;
  final String userId;
  final String profilePicture;
  final String cellNo;
  final bool kycVerified;
  final String dob;
  final String referralCode;
  final String? appliedReferralCode;
  final String proPicExtension;

  final Map<String, String?> savedAddress;
  final Map<String, String?> bankDetails;
  final Map<String, String?> nomineeDetails;

  UserProfileModel({
    required this.gender,
    required this.emailId,
    required this.userName,
    required this.userId,
    required this.profilePicture,
    required this.cellNo,
    required this.kycVerified,
    required this.dob,
    required this.referralCode,
    required this.proPicExtension,
    required this.appliedReferralCode,
    required this.savedAddress,
    required this.bankDetails,
    required this.nomineeDetails,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return UserProfileModel(
      gender: data['gender'] ?? '',
      emailId: data['emailId'] ?? '',
      userName: data['userName'] ?? '',
      userId: data['userId'] ?? '',
      profilePicture: data['profilePicture'] ?? '',
      cellNo: data['cellNo'] ?? '',
      kycVerified: data['KycVerified'] ?? false,
      dob: data['dob'] ?? '',
      referralCode: data['referralCode'] ?? '',
      proPicExtension: data['proPicExtension'] ?? '',
      appliedReferralCode: data['appliedReferralCode'],
      savedAddress: Map<String, String?>.from(data['savedAddress'] ?? {}),
      bankDetails: Map<String, String?>.from(data['bankDetails'] ?? {}),
      nomineeDetails: Map<String, String?>.from(data['nomineeDetails'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'UserProfileModel('
        'userId: $userId, '
        'userName: $userName, '
        'emailId: $emailId, '
        'gender: $gender, '
        'dob: $dob, '
        'cellNo: $cellNo, '
        'kycVerified: $kycVerified, '
        'referralCode: $referralCode, '
        'appliedReferralCode: $appliedReferralCode, '
        'profilePicture: ${profilePicture.isNotEmpty ? "Available (Base64 - ${profilePicture.length} chars)" : "Not available"}, '
        'proPicExtension: $proPicExtension, '
        'savedAddress: $savedAddress, '
        'bankDetails: $bankDetails, '
        'nomineeDetails: $nomineeDetails'
        ')';
  }
}
