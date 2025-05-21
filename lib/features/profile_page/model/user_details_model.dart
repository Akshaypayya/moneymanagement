class UserDetailsModel {
  UserDetailsModel({this.userData, this.status, this.message});
  // UserDetailsModel.fromJson(dynamic json) {
  //   if (json['userData'] != null) {
  //     userData = UserData.fromJson(json['userData']);
  //   } else if (json['userData'] != null) {
  //     userData = UserData.fromJson(json['userData']);
  //   }
  //   status = json['status'];
  //   message = json['message'];
  // }
  UserDetailsModel.fromJson(dynamic json) {
    if (json['data'] != null) {
      userData = UserData.fromJson(json['data']);
    }
    status = json['status'];
    message = json['message'];
  }
  UserData? userData;
  String? status;
  String? message;

  UserDetailsModel copyWith({
    UserData? userData,
    String? status,
    String? message,
  }) =>
      UserDetailsModel(
        userData: userData ?? this.userData,
        status: status ?? this.status,
        message: message ?? this.message,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userData != null) {
      map['userData'] = userData?.toJson();
    }
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}

class UserData {
  UserData({
    this.gender,
    this.profileCompletion,
    this.emailId,
    this.userName,
    this.userId,
    this.profilePicture,
    this.bankDetails,
    this.cellNo,
    this.nomineeDetails,
    this.appliedReferralCode,
    this.kycVerified,
    this.dob,
    this.referralCode,
    this.savedAddress,
    this.proPicExtension,
  });

  // UserData.fromJson(dynamic json) {
  //   gender = json['gender'];
  //   profileCompletion = json['profileCompletion'];
  //   emailId = json['emailId'];
  //   userName = json['userName'];
  //   userId = json['userId'];
  //   profilePicture = json['profilePicture'];
  //   bankDetails = json['bankDetails'] != null
  //       ? BankDetails.fromJson(json['bankDetails'])
  //       : null;
  //   cellNo = json['cellNo'];
  //   nomineeDetails = NomineeDetails.fromJson(json["nomineeDetails"]);
  //   appliedReferralCode = json['appliedReferralCode'];
  //   kycVerified = json['KycVerified'];
  //   dob = json['dob'];
  //   referralCode = json['referralCode'];
  //   savedAddress = json['savedAddress'] != null
  //       ? SavedAddress.fromJson(json['savedAddress'])
  //       : null;
  //   proPicExtension = json['proPicExtension'];
  // }
  UserData.fromJson(Map<String, dynamic> json) {
    gender = json['gender'];
    profileCompletion = json['profileCompletion'];
    emailId = json['emailId'];
    userName = json['userName'];
    userId = json['userId'];
    profilePicture = json['profilePicture'];
    bankDetails = json['bankDetails'] != null
        ? BankDetails.fromJson(json['bankDetails'])
        : null;
    cellNo = json['cellNo'];
    nomineeDetails = json['nomineeDetails'] != null
        ? NomineeDetails.fromJson(json['nomineeDetails'])
        : null;
    kycVerified = json['KycVerified'];
    dob = json['dob'];
    savedAddress = json['savedAddress'] != null
        ? SavedAddress.fromJson(json['savedAddress'])
        : null;
    proPicExtension = json['proPicExtension'];
  }
  String? gender;
  num? profileCompletion;
  String? emailId;
  String? userName;
  String? userId;
  String? profilePicture;
  BankDetails? bankDetails;
  String? cellNo;
  dynamic nomineeDetails;
  dynamic appliedReferralCode;
  bool? kycVerified;
  String? dob;
  String? referralCode;
  SavedAddress? savedAddress;
  String? proPicExtension;

  UserData copyWith({
    String? gender,
    num? profileCompletion,
    String? emailId,
    String? userName,
    String? userId,
    String? profilePicture,
    BankDetails? bankDetails,
    String? cellNo,
    dynamic nomineeDetails,
    dynamic appliedReferralCode,
    bool? kycVerified,
    String? dob,
    String? referralCode,
    SavedAddress? savedAddress,
    String? proPicExtension,
  }) =>
      UserData(
        gender: gender ?? this.gender,
        profileCompletion: profileCompletion ?? this.profileCompletion,
        emailId: emailId ?? this.emailId,
        userName: userName ?? this.userName,
        userId: userId ?? this.userId,
        profilePicture: profilePicture ?? this.profilePicture,
        bankDetails: bankDetails ?? this.bankDetails,
        cellNo: cellNo ?? this.cellNo,
        nomineeDetails: nomineeDetails ?? this.nomineeDetails,
        appliedReferralCode: appliedReferralCode ?? this.appliedReferralCode,
        kycVerified: kycVerified ?? this.kycVerified,
        dob: dob ?? this.dob,
        referralCode: referralCode ?? this.referralCode,
        savedAddress: savedAddress ?? this.savedAddress,
        proPicExtension: proPicExtension ?? this.proPicExtension,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gender'] = gender;
    map['profileCompletion'] = profileCompletion;
    map['emailId'] = emailId;
    map['userName'] = userName;
    map['userId'] = userId;
    map['profilePicture'] = profilePicture;
    if (bankDetails != null) {
      map['bankDetails'] = bankDetails?.toJson();
    }
    map['cellNo'] = cellNo;
    map['nomineeDetails'] = nomineeDetails!.toJson();
    map['appliedReferralCode'] = appliedReferralCode;
    map['KycVerified'] = kycVerified;
    map['dob'] = dob;
    map['referralCode'] = referralCode;
    if (savedAddress != null) {
      map['savedAddress'] = savedAddress?.toJson();
    }
    map['proPicExtension'] = proPicExtension;
    return map;
  }
}

class BankDetails {
  String? nameOnAcc;
  String? accNo;
  dynamic reAccNo;
  dynamic ifsc;
  String? status;

  BankDetails({
    this.nameOnAcc,
    this.accNo,
    this.reAccNo,
    this.ifsc,
    this.status,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        nameOnAcc: json["nameOnAcc"],
        accNo: json["accNo"],
        reAccNo: json["reAccNo"],
        ifsc: json["ifsc"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "nameOnAcc": nameOnAcc,
        "accNo": accNo,
        "reAccNo": reAccNo,
        "ifsc": ifsc,
        "status": status,
      };
}

class NomineeDetails {
  String? nomineeName;
  String? nomineeRelation;
  String? nomineeDob;

  NomineeDetails({
    this.nomineeName,
    this.nomineeRelation,
    this.nomineeDob,
  });

  factory NomineeDetails.fromJson(Map<String, dynamic> json) => NomineeDetails(
        nomineeName: json["nomineeName"],
        nomineeRelation: json["nomineeRelation"],
        nomineeDob: json["nomineeDob"],
      );

  Map<String, dynamic> toJson() => {
        "nomineeName": nomineeName,
        "nomineeRelation": nomineeRelation,
        "nomineeDob": nomineeDob,
      };
}

class SavedAddress {
  dynamic pinCode;
  dynamic streetAddress1;
  dynamic streetAddress2;
  dynamic city;
  dynamic state;

  SavedAddress({
    this.pinCode,
    this.streetAddress1,
    this.streetAddress2,
    this.city,
    this.state,
  });

  factory SavedAddress.fromJson(Map<String, dynamic> json) => SavedAddress(
        pinCode: json["pinCode"],
        streetAddress1: json["streetAddress1"],
        streetAddress2: json["streetAddress2"],
        city: json["city"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "pinCode": pinCode,
        "streetAddress1": streetAddress1,
        "streetAddress2": streetAddress2,
        "city": city,
        "state": state,
      };
}
