class NomineeDetailsModel {
  final Map<String, String> data;
  final String status;
  final String message;

  NomineeDetailsModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory NomineeDetailsModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>? ?? {};
    final formattedData = rawData.map((key, value) => MapEntry(key, value.toString()));

    return NomineeDetailsModel(
      data: formattedData,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }
}
