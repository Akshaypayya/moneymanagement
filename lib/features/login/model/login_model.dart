class LoginResponse {
  final String status;
  final String message;
  final Map<String, String>? data;

  LoginResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as Map?)?.map(
            (key, value) => MapEntry(key.toString(), value.toString()),
      ),
    );
  }

  bool get isSuccess => status == 'Success';
  bool get isValidationFailed => status == 'ValidationFailed';
}
