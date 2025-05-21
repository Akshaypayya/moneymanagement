class LogoutModel {
  final String status;
  final String? message;

  LogoutModel({
    required this.status,
    this.message,
  });

  factory LogoutModel.fromJson(Map<String, dynamic> json) {
    return LogoutModel(
      status: json['status'] ?? '',
      message: json['message'],
    );
  }

  bool get isSuccess => status == 'Success';
}
