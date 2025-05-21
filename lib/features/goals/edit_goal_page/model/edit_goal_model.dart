class EditGoalModel {
  final String? data;
  final String status;
  final String message;

  EditGoalModel({
    this.data,
    required this.status,
    required this.message,
  });

  factory EditGoalModel.fromJson(Map<String, dynamic> json) {
    return EditGoalModel(
      data: json['data'] != null ? json['data'].toString() : null,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status == 'Success';
  bool get isValidationFailed => status == 'ValidationFailed';
}
