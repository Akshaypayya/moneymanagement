class SellGoldModel {
  SellGoldModel({
      this.status, 
      this.message,});

  SellGoldModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
  }
  String? status;
  String? message;
SellGoldModel copyWith({  String? status,
  String? message,
}) => SellGoldModel(  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}