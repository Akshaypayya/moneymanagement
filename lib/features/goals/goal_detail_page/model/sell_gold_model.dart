class SellGoldRequest {
  final String goalName;
  final String transactionId;

  SellGoldRequest({
    required this.goalName,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
      'transactionId': transactionId,
    };
  }

  @override
  String toString() {
    return 'SellGoldRequest(goalName: $goalName, transactionId: $transactionId)';
  }
}

class SellGoldResponse {
  final SellGoldData? data;
  final String status;
  final String message;

  SellGoldResponse({
    this.data,
    required this.status,
    required this.message,
  });

  factory SellGoldResponse.fromJson(Map<String, dynamic> json) {
    return SellGoldResponse(
      data: json['data'] != null ? SellGoldData.fromJson(json['data']) : null,
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status == 'Success';

  @override
  String toString() {
    return 'SellGoldResponse(status: $status, message: $message, data: $data)';
  }
}

class SellGoldData {
  final double goldSold;
  final double soldPrice;
  final String currencyCode;

  SellGoldData({
    required this.goldSold,
    required this.soldPrice,
    required this.currencyCode,
  });

  factory SellGoldData.fromJson(Map<String, dynamic> json) {
    return SellGoldData(
      goldSold: (json['goldSold'] ?? 0).toDouble(),
      soldPrice: (json['soldPrice'] ?? 0).toDouble(),
      currencyCode: json['currencyCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goldSold': goldSold,
      'soldPrice': soldPrice,
      'currencyCode': currencyCode,
    };
  }

  String get formattedGoldSold => goldSold.toString();
  String get formattedSoldPrice => soldPrice.toString();

  @override
  String toString() {
    return 'SellGoldData(goldSold: $goldSold, soldPrice: $soldPrice, currencyCode: $currencyCode)';
  }
}
