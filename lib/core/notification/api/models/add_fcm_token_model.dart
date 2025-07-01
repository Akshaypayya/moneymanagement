class AddFcmTokenModel {
  AddFcmTokenModel({
      this.status, 
      this.message,});

  AddFcmTokenModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;
AddFcmTokenModel copyWith({  String? status,
  String? message,
}) => AddFcmTokenModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }
}