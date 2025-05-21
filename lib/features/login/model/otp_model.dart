class OtpResponse {
  final String status;
  final String? message;
  final Map<String, dynamic>? data;

  OtpResponse({
    required this.status,
    this.message,
    this.data,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      status: json['status'] ?? '',
      message: json['message'],
      data: json['data'],
    );
  }

  bool get isSuccess => status == 'Success';
}
