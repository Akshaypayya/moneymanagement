class UpdateUserDetailsRequestModel {
  final String userName;
  final String emailId;
  final String dob;
  final String gender;

  UpdateUserDetailsRequestModel({
    required this.userName,
    required this.emailId,
    required this.dob,
    required this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'emailId': emailId,
      'dob': dob,
      'gender': gender,
    };
  }
}
