class TransferAmountRequest {
  final String goalName;
  final double amount;

  TransferAmountRequest({
    required this.goalName,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'TransferAmountRequest(goalName: $goalName, amount: $amount)';
  }
}

class TransferAmountResponse {
  final String status;
  final String message;

  TransferAmountResponse({
    required this.status,
    required this.message,
  });

  factory TransferAmountResponse.fromJson(Map<String, dynamic> json) {
    return TransferAmountResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status == 'Success';

  @override
  String toString() {
    return 'TransferAmountResponse(status: $status, message: $message)';
  }
}
