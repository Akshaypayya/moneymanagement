class BankResponse {
  final String status;
  final String message;
  final Map<String, String>? data;

  BankResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    return BankResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as Map?)?.map(
            (k, v) => MapEntry(k.toString(), v.toString()),
      ),
    );
  }

  bool get isSuccess => status == 'Success';
  bool get isValidationFailed => status == 'ValidationFailed';
}
