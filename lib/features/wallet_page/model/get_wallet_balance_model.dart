class GetWalletBalanceModel {
  GetWalletBalanceModel({
      this.data, 
      this.status, 
      this.message,});

  GetWalletBalanceModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }
  Data? data;
  String? status;
  String? message;
GetWalletBalanceModel copyWith({  Data? data,
  String? status,
  String? message,
}) => GetWalletBalanceModel(  data: data ?? this.data,
  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
      this.walletVA, 
      this.walletBalance, 
      this.goldBalance,});

  Data.fromJson(dynamic json) {
    walletVA = json['walletVA'];
    walletBalance = json['walletBalance'];
    goldBalance = json['goldBalance'];
  }
  String? walletVA;
  num? walletBalance;
  num? goldBalance;
Data copyWith({  String? walletVA,
  num? walletBalance,
  num? goldBalance,
}) => Data(  walletVA: walletVA ?? this.walletVA,
  walletBalance: walletBalance ?? this.walletBalance,
  goldBalance: goldBalance ?? this.goldBalance,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['walletVA'] = walletVA;
    map['walletBalance'] = walletBalance;
    map['goldBalance'] = goldBalance;
    return map;
  }

}