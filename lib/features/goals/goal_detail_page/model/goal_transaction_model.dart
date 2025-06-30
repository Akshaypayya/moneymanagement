import 'package:intl/intl.dart';

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
    int flagToUse = drcrFlag;

    if (drcrFlag == 0) {
      flagToUse = sequence;
    }

    switch (flagToUse) {
      case 1:
        return currencyCode == 'XAU' ? 'Gold Purchase' : 'Deposit';
      case 2:
        return 'Withdrawal';
      case 3:
        return 'Transaction Charge';
      case 4:
        return 'VAT Charge';
      default:
        return 'Transaction';
    }
  }

  bool get isCredit {
    int flagToUse = drcrFlag;
    if (drcrFlag == 0) {
      flagToUse = sequence;
    }
    return flagToUse == 1;
  }

  bool get isDebit {
    int flagToUse = drcrFlag;
    if (drcrFlag == 0) {
      flagToUse = sequence;
    }
    return flagToUse == 2 || flagToUse == 3 || flagToUse == 4;
  }

  String get signedDisplayAmount {
    String baseAmount = displayAmount;

    if (isDebit) {
      return '-$baseAmount';
    } else if (isCredit) {
      return '+$baseAmount';
    }

    return baseAmount;
  }

  getFormattedDate() {
    String dateStr = transactionDate;
    DateTime utcTime = DateTime.parse(dateStr);
    DateTime localTime = utcTime.toLocal();
    String formatted = DateFormat('dd MMM yyyy – hh:mm a').format(localTime);
    return formatted;
  }

  String get description {
    switch (transactionType) {
      case 'Gold Purchase':
        return 'Gold purchased for your ${accountSubGroup ?? 'goal'}. Amount auto-debited from your account.';
      case 'Deposit':
        return 'Amount deposited to your ${accountSubGroup ?? 'goal'} savings.';
      case 'Withdrawal':
        return 'Amount withdrawn from your ${accountSubGroup ?? 'goal'}.';
      case 'Transaction Charge':
        return 'Transaction charges and fees applied.';
      case 'VAT Charge':
        return 'VAT charges applied to your transaction.';
      default:
        return 'Transaction processed for your ${accountSubGroup ?? 'goal'}.';
    }
  }

  String get iconAsset {
    switch (transactionType) {
      case 'Gold Purchase':
        return 'assets/goldbsct.png';
      case 'Transaction Charge':
      case 'VAT Charge':
        return 'assets/bank.jpg';
    }

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
        return 'assets/bank.jpg';
    }
  }

  String get debugInfo {
    return 'drcrFlag: $drcrFlag, sequence: $sequence, type: $transactionType, isCredit: $isCredit, isDebit: $isDebit';
  }
}
