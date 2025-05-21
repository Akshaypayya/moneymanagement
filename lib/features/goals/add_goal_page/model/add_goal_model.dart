class CreateGoalModel {
  final CreateGoalData? data;
  final String status;
  final String message;

  CreateGoalModel({
    this.data,
    required this.status,
    required this.message,
  });

  factory CreateGoalModel.fromJson(Map<String, dynamic> json) {
    return CreateGoalModel(
      data: json['data'] != null ? CreateGoalData.fromJson(json['data']) : null,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status == 'Success';
  bool get isValidationFailed => status == 'ValidationFailed';
  bool get isKycRequired => status == 'VerifyKYC';
  bool get hasVirtualAccount => data?.virtualAccount != null;

  String get validationErrors {
    if (isValidationFailed && data != null) {
      if (data!.toJson().isNotEmpty) {
        return data!
            .toJson()
            .entries
            .map((e) => '${e.key}: ${e.value}')
            .join(', ');
      }
    }
    return message;
  }
}

class CreateGoalData {
  final String? virtualAccount;
  final Map<String, dynamic> _rawData;

  CreateGoalData({
    this.virtualAccount,
    Map<String, dynamic>? rawData,
  }) : _rawData = rawData ?? {};

  factory CreateGoalData.fromJson(Map<String, dynamic> json) {
    return CreateGoalData(
      virtualAccount: json['virtualAccount'],
      rawData: json,
    );
  }

  Map<String, dynamic> toJson() {
    return _rawData;
  }
}
