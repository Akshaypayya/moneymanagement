class SellGoldRequest {
  final String goalName;

  SellGoldRequest({
    required this.goalName,
  });

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
    };
  }

  @override
  String toString() {
    return 'SellGoldRequest(goalName: $goalName)';
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
  final int goldSold;
  final int soldPrice;
  final String currencyCode;

  SellGoldData({
    required this.goldSold,
    required this.soldPrice,
    required this.currencyCode,
  });

  factory SellGoldData.fromJson(Map<String, dynamic> json) {
    return SellGoldData(
      goldSold: json['goldSold'] ?? 0,
      soldPrice: json['soldPrice'] ?? 0,
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
