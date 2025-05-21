class ApplyRefCodeModel {
  ApplyRefCodeModel({
      this.status, 
      this.message,});

  ApplyRefCodeModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;
ApplyRefCodeModel copyWith({  String? status,
  String? message,
}) => ApplyRefCodeModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}