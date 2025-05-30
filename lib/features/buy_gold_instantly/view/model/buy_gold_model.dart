class BuyGoldModel {
  BuyGoldModel({
      this.data, 
      this.status, 
      this.message,});

  BuyGoldModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }
  Data? data;
  String? status;
  String? message;
BuyGoldModel copyWith({  Data? data,
  String? status,
  String? message,
}) => BuyGoldModel(  data: data ?? this.data,
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
      this.debitCurrency, 
      this.debitAmount, 
      this.goldPurchasedAmount, 
      this.goldPurchased,});

  Data.fromJson(dynamic json) {
    debitCurrency = json['debitCurrency'];
    debitAmount = json['debitAmount'];
    goldPurchasedAmount = json['goldPurchasedAmount'];
    goldPurchased = json['goldPurchased'];
  }
  String? debitCurrency;
  num? debitAmount;
  num? goldPurchasedAmount;
  num? goldPurchased;
Data copyWith({  String? debitCurrency,
  num? debitAmount,
  num? goldPurchasedAmount,
  num? goldPurchased,
}) => Data(  debitCurrency: debitCurrency ?? this.debitCurrency,
  debitAmount: debitAmount ?? this.debitAmount,
  goldPurchasedAmount: goldPurchasedAmount ?? this.goldPurchasedAmount,
  goldPurchased: goldPurchased ?? this.goldPurchased,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['debitCurrency'] = debitCurrency;
    map['debitAmount'] = debitAmount;
    map['goldPurchasedAmount'] = goldPurchasedAmount;
    map['goldPurchased'] = goldPurchased;
    return map;
  }

}