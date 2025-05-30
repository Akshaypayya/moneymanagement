class GetHomeDetailsModel {
  GetHomeDetailsModel({
    this.data,
    this.status,
    this.message,  // added message field
  });

  GetHomeDetailsModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];  // parse message
  }

  Data? data;
  String? status;
  String? message;  // added message field

  GetHomeDetailsModel copyWith({
    Data? data,
    String? status,
    String? message,  // added to copyWith
  }) =>
      GetHomeDetailsModel(
        data: data ?? this.data,
        status: status ?? this.status,
        message: message ?? this.message,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['status'] = status;
    if (message != null) {
      map['message'] = message;  // include message in toJson
    }
    return map;
  }
}

class Data {
  Data({
    this.buyPrice,
    this.walletBalance,
    this.totalBalance,
    this.currentPrice,
    this.goldBalance,
  });

  Data.fromJson(dynamic json) {
    buyPrice = json['buyPrice'];
    walletBalance = json['walletBalance'];
    totalBalance = json['totalBalance'];
    currentPrice = json['currentPrice'];
    goldBalance = json['goldBalance'];
  }

  num? buyPrice;
  num? walletBalance;
  num? totalBalance;
  num? currentPrice;
  num? goldBalance;

  Data copyWith({
    num? buyPrice,
    num? walletBalance,
    num? totalBalance,
    num? currentPrice,
    num? goldBalance,
  }) =>
      Data(
        buyPrice: buyPrice ?? this.buyPrice,
        walletBalance: walletBalance ?? this.walletBalance,
        totalBalance: totalBalance ?? this.totalBalance,
        currentPrice: currentPrice ?? this.currentPrice,
        goldBalance: goldBalance ?? this.goldBalance,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['buyPrice'] = buyPrice;
    map['walletBalance'] = walletBalance;
    map['totalBalance'] = totalBalance;
    map['currentPrice'] = currentPrice;
    map['goldBalance'] = goldBalance;
    return map;
  }
}
