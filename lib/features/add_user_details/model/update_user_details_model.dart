class UpdateUserDetailsModel {
  final Map<String, String>? data;
  final String status;
  final String message;

  UpdateUserDetailsModel({
    required this.data,
    required this.status,
    required this.message,
  });

  factory UpdateUserDetailsModel.fromJson(Map<String, dynamic> json) {
    return UpdateUserDetailsModel(
      data: (json['data'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value.toString()),
      ),
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
}
