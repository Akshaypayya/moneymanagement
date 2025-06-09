class InitiateSellGoldRequest {
  final String goalName;
  final int operation;

  InitiateSellGoldRequest({
    required this.goalName,
    required this.operation,
  });

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
      'operation': operation,
    };
  }

  @override
  String toString() {
    return 'InitiateSellGoldRequest(goalName: $goalName, operation: $operation)';
  }
}

class InitiateSellGoldResponse {
  final InitiateSellGoldData? data;
  final String status;
  final String? message;

  InitiateSellGoldResponse({
    this.data,
    required this.status,
    this.message,
  });

  factory InitiateSellGoldResponse.fromJson(Map<String, dynamic> json) {
    return InitiateSellGoldResponse(
      data: json['data'] != null
          ? InitiateSellGoldData.fromJson(json['data'])
          : null,
      status: json['status'] ?? '',
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

  bool get isSuccess => status == 'Success';

  @override
  String toString() {
    return 'InitiateSellGoldResponse(status: $status, message: $message, data: $data)';
  }
}

class InitiateSellGoldData {
  final double? transactionAmount;
  final double chargeAmount;
  final String transactionId;

  InitiateSellGoldData({
    this.transactionAmount,
    required this.chargeAmount,
    required this.transactionId,
  });

  factory InitiateSellGoldData.fromJson(Map<String, dynamic> json) {
    return InitiateSellGoldData(
      transactionAmount: json['transactionAmount']?.toDouble(),
      chargeAmount: (json['chargeAmount'] ?? 0).toDouble(),
      transactionId: json['transactionId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactionAmount': transactionAmount,
      'chargeAmount': chargeAmount,
      'transactionId': transactionId,
    };
  }

  String get formattedTransactionAmount =>
      transactionAmount?.toStringAsFixed(2) ?? '0.00';
  String get formattedChargeAmount => chargeAmount.toStringAsFixed(2);

  @override
  String toString() {
    return 'InitiateSellGoldData(transactionAmount: $transactionAmount, chargeAmount: $chargeAmount, transactionId: $transactionId)';
  }
}
