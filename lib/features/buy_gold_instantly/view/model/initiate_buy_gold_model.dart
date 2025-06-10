class InitiateBuyGoldModel {
  final InitiateBuyGoldData? data;
  final String? status;
  final String? message;

  InitiateBuyGoldModel({
    this.data,
    this.status,
    this.message,
  });

  factory InitiateBuyGoldModel.fromJson(Map<String, dynamic> json) {
    return InitiateBuyGoldModel(
      data: json['data'] != null ? InitiateBuyGoldData.fromJson(json['data']) : null,
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
      'message': message,
    };
  }
}

class InitiateBuyGoldData {
  final num? transactionAmount;
  final num? chargeAmount;
  final num? sellPrice;
  final String? transactionId;

  InitiateBuyGoldData({
    this.transactionAmount,
    this.chargeAmount,
    this.sellPrice,
    this.transactionId,
  });

  factory InitiateBuyGoldData.fromJson(Map<String, dynamic> json) {
    return InitiateBuyGoldData(
      transactionAmount: json['transactionAmount'],
      chargeAmount: json['chargeAmount'],
      sellPrice: json['sellPrice'],
      transactionId: json['transactionId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionAmount': transactionAmount,
      'chargeAmount': chargeAmount,
      'sellPrice': sellPrice,
      'transactionId': transactionId,
    };
  }

  InitiateBuyGoldData copyWith({
    num? transactionAmount,
    num? chargeAmount,
    num? sellPrice,
    String? transactionId,
  }) {
    return InitiateBuyGoldData(
      transactionAmount: transactionAmount ?? this.transactionAmount,
      chargeAmount: chargeAmount ?? this.chargeAmount,
      sellPrice: sellPrice ?? this.sellPrice,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
