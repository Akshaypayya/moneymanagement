class ProfilePictureModel {
  final String status;
  final String message;

  ProfilePictureModel({
    required this.status,
    required this.message,
  });

  factory ProfilePictureModel.fromJson(Map<String, dynamic> json) {
    return ProfilePictureModel(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  bool get isSuccess => status == 'success';
}
