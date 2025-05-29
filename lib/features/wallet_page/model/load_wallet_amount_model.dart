class LoadWalletAmountModel {
  LoadWalletAmountModel({
      this.status,});

  LoadWalletAmountModel.fromJson(dynamic json) {
    status = json['status'];
  }
  String? status;
LoadWalletAmountModel copyWith({  String? status,
}) => LoadWalletAmountModel(  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    return map;
  }

}