class GoalTransactionModel {
  final GoalTransactionData? data;
  final String status;

  GoalTransactionModel({
    this.data,
    required this.status,
  });

  factory GoalTransactionModel.fromJson(Map<String, dynamic> json) {
    return GoalTransactionModel(
      data: json['data'] != null
          ? GoalTransactionData.fromJson(json['data'])
          : null,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
    };
  }

  bool get isSuccess => status == 'Success';
}

class GoalTransactionData {
  final int iTotalRecords;
  final int iTotalDisplayRecords;
  final List<TransactionItem> aaData;

  GoalTransactionData({
    required this.iTotalRecords,
    required this.iTotalDisplayRecords,
    required this.aaData,
  });

  factory GoalTransactionData.fromJson(Map<String, dynamic> json) {
    return GoalTransactionData(
      iTotalRecords: json['iTotalRecords'] ?? 0,
      iTotalDisplayRecords: json['iTotalDisplayRecords'] ?? 0,
      aaData: json['aaData'] != null
          ? (json['aaData'] as List)
              .map((item) => TransactionItem.fromJson(item))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iTotalRecords': iTotalRecords,
      'iTotalDisplayRecords': iTotalDisplayRecords,
      'aaData': aaData.map((item) => item.toJson()).toList(),
    };
  }
}

class TransactionItem {
  final double amount;
  final double? operationPrice;
  final String paymentMode;
  final String bankReference;
  final String currencyCode;
  final String operationCurrencyCode;
  final String transactionDate;
  final int drcrFlag;
  final int sequence;
  final String? accountGroup;
  final String? accountSubGroup;
  final String transactionCode;
  final double? chargeAmount;
  final double? vatAmount;

  TransactionItem({
    required this.amount,
    this.operationPrice,
    required this.paymentMode,
    required this.bankReference,
    required this.currencyCode,
    required this.operationCurrencyCode,
    required this.transactionDate,
    required this.drcrFlag,
    required this.sequence,
    this.accountGroup,
    this.accountSubGroup,
    required this.transactionCode,
    this.chargeAmount,
    this.vatAmount,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      amount: (json['amount'] ?? 0).toDouble(),
      operationPrice: json['operationPrice']?.toDouble(),
      paymentMode: json['paymentMode'] ?? '',
      bankReference: json['bankReference'] ?? '',
      currencyCode: json['currencyCode'] ?? '',
      operationCurrencyCode: json['operationCurrencyCode'] ?? '',
      transactionDate: json['transactionDate'] ?? '',
      drcrFlag: json['drcrFlag'] ?? 0,
      sequence: json['sequence'] ?? 0,
      accountGroup: json['accountGroup'],
      accountSubGroup: json['accountSubGroup'],
      transactionCode: json['transactionCode'] ?? '',
      chargeAmount: json['chargeAmount']?.toDouble(),
      vatAmount: json['vatAmount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'operationPrice': operationPrice,
      'paymentMode': paymentMode,
      'bankReference': bankReference,
      'currencyCode': currencyCode,
      'operationCurrencyCode': operationCurrencyCode,
      'transactionDate': transactionDate,
      'drcrFlag': drcrFlag,
      'sequence': sequence,
      'accountGroup': accountGroup,
      'accountSubGroup': accountSubGroup,
      'transactionCode': transactionCode,
      'chargeAmount': chargeAmount,
      'vatAmount': vatAmount,
    };
  }

  String get formattedAmount => amount.toStringAsFixed(2);

  String get displayAmount {
    if (currencyCode == 'XAU') {
      return '${amount.toStringAsFixed(3)} gm';
    }
    return formattedAmount;
  }

  String get transactionType {
    if (drcrFlag == 1) {
      return currencyCode == 'XAU' ? 'Gold Purchase' : 'Deposit';
    } else {
      return 'Charge';
    }
  }

  String get formattedDate {
    try {
      final dateTime = DateTime.parse(transactionDate);
      return '${dateTime.day.toString().padLeft(2, '0')} ${_getMonthName(dateTime.month)} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    } catch (e) {
      return transactionDate;
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  String get description {
    switch (transactionType) {
      case 'Gold Purchase':
        return 'Gold purchased for your ${accountSubGroup ?? 'goal'}. Amount auto-debited from your account.';
      case 'Deposit':
        return 'Amount deposited to your ${accountSubGroup ?? 'goal'} savings.';
      case 'Charge':
        return 'Transaction charges and fees applied.';
      default:
        return 'Transaction processed for your ${accountSubGroup ?? 'goal'}.';
    }
  }

  String get iconAsset {
    switch (paymentMode.toLowerCase()) {
      case 'upi':
        return 'assets/bhim.png';
      case 'bank':
      case 'neft':
      case 'rtgs':
        return 'assets/bank.jpg';
      default:
        if (currencyCode == 'XAU') {
          return 'assets/goldbsct.png';
        }
        return 'assets/bhim.png';
    }
  }
}
