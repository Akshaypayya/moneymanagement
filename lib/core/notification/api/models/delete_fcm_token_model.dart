class DeleteFcmTokenModel {
  DeleteFcmTokenModel({
      this.status, 
      this.message,});

  DeleteFcmTokenModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;
DeleteFcmTokenModel copyWith({  String? status,
  String? message,
}) => DeleteFcmTokenModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}