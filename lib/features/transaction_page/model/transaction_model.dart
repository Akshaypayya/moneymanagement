import 'package:flutter/material.dart';

class TransactionModel {
  final TransactionData? data;
  final String status;
  final String? message;

  TransactionModel({
    this.data,
    required this.status,
    this.message,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    debugPrint('PARSING TransactionModel from: ${json.keys.toList()}');

    return TransactionModel(
      data:
          json['data'] != null ? TransactionData.fromJson(json['data']) : null,
      status: json['status']?.toString() ?? 'Unknown',
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status.toLowerCase() == 'success';
}

class TransactionData {
  final int iTotalRecords;
  final int iTotalDisplayRecords;
  final List<TransactionApiModel> aaData;

  TransactionData({
    required this.iTotalRecords,
    required this.iTotalDisplayRecords,
    required this.aaData,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    debugPrint('PARSING TransactionData from: ${json.keys.toList()}');

    int totalRecords = 0;
    int displayRecords = 0;
    List<TransactionApiModel> transactions = [];

    if (json.containsKey('iTotalRecords')) {
      totalRecords = json['iTotalRecords'] as int? ?? 0;
    } else if (json.containsKey('totalRecords')) {
      totalRecords = json['totalRecords'] as int? ?? 0;
    } else if (json.containsKey('total')) {
      totalRecords = json['total'] as int? ?? 0;
    }

    if (json.containsKey('iTotalDisplayRecords')) {
      displayRecords = json['iTotalDisplayRecords'] as int? ?? 0;
    } else if (json.containsKey('displayRecords')) {
      displayRecords = json['displayRecords'] as int? ?? 0;
    } else {
      displayRecords = totalRecords;
    }

    List<dynamic>? transactionArray;
    if (json.containsKey('aaData')) {
      transactionArray = json['aaData'] as List<dynamic>?;
    } else if (json.containsKey('data')) {
      transactionArray = json['data'] as List<dynamic>?;
    } else if (json.containsKey('transactions')) {
      transactionArray = json['transactions'] as List<dynamic>?;
    } else if (json.containsKey('items')) {
      transactionArray = json['items'] as List<dynamic>?;
    }

    if (transactionArray != null) {
      debugPrint(
          'PARSING: Found ${transactionArray.length} transactions in array');
      try {
        transactions = transactionArray
            .map((item) =>
                TransactionApiModel.fromJson(item as Map<String, dynamic>))
            .toList();
        debugPrint(
            'PARSING: Successfully parsed ${transactions.length} transaction models');
      } catch (e) {
        debugPrint('PARSING ERROR: Failed to parse transactions: $e');
        debugPrint(
            'PARSING ERROR: Sample item: ${transactionArray.isNotEmpty ? transactionArray.first : 'EMPTY'}');
      }
    }

    return TransactionData(
      iTotalRecords: totalRecords,
      iTotalDisplayRecords: displayRecords,
      aaData: transactions,
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

class TransactionApiModel {
  final int amount;
  final int? operationPrice;
  final String paymentMode;
  final String bankReference;
  final String currencyCode;
  final String operationCurrencyCode;
  final String transactionDate;
  final int drcrFlag;
  final int sequence;
  final String? accountGroup;
  final String accountSubGroup;
  final String transactionCode;
  final int? chargeAmount;
  final int? vatAmount;

  TransactionApiModel({
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
    required this.accountSubGroup,
    required this.transactionCode,
    this.chargeAmount,
    this.vatAmount,
  });

  factory TransactionApiModel.fromJson(Map<String, dynamic> json) {
    debugPrint('PARSING TransactionApiModel from: ${json.keys.toList()}');

    try {
      return TransactionApiModel(
        amount: _parseNumber(json['amount']) ?? 0,
        operationPrice: _parseNumber(json['operationPrice']),
        paymentMode: json['paymentMode']?.toString() ?? 'Unknown',
        bankReference: json['bankReference']?.toString() ?? '',
        currencyCode: json['currencyCode']?.toString() ?? 'SAR',
        operationCurrencyCode:
            json['operationCurrencyCode']?.toString() ?? 'SAR',
        transactionDate: json['transactionDate']?.toString() ??
            DateTime.now().toIso8601String(),
        drcrFlag: _parseNumber(json['drcrFlag']) ?? 0,
        sequence: _parseNumber(json['sequence']) ?? 0,
        accountGroup: json['accountGroup']?.toString(),
        accountSubGroup: json['accountSubGroup']?.toString() ?? '',
        transactionCode: json['transactionCode']?.toString() ?? '',
        chargeAmount: _parseNumber(json['chargeAmount']),
        vatAmount: _parseNumber(json['vatAmount']),
      );
    } catch (e) {
      debugPrint('PARSING ERROR for TransactionApiModel: $e');
      debugPrint('PARSING ERROR JSON: $json');
      rethrow;
    }
  }

  static int? _parseNumber(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
      final parsedDouble = double.tryParse(value);
      if (parsedDouble != null) return parsedDouble.round();
    }
    return null;
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

  String get formattedAmount {
    try {
      final displayAmount = amount / 100.0;
      return displayAmount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return '0.00';
    }
  }

  bool get isDebit => drcrFlag == 1;
  bool get isCredit => drcrFlag == 0;

  String get transactionType => isDebit ? 'Debit' : 'Credit';

  String get goalBasedIcon {
    final subGroup = accountSubGroup.toLowerCase();

    if (subGroup.contains('education') || subGroup.contains('study')) {
      return 'assets/education.png';
    } else if (subGroup.contains('home') || subGroup.contains('house')) {
      return 'assets/home.png';
    } else if (subGroup.contains('wedding') || subGroup.contains('marriage')) {
      return 'assets/wedding.png';
    } else if (subGroup.contains('trip') || subGroup.contains('travel')) {
      return 'assets/trip.png';
    } else {
      return transactionIcon;
    }
  }

  String get transactionIcon {
    switch (paymentMode.toLowerCase()) {
      case 'upi':
        return 'assets/bhim.png';
      case 'bank':
      case 'netbanking':
        return 'assets/bank.jpg';
      case 'gold':
        return 'assets/goldbsct.png';
      default:
        return 'assets/bank.jpg';
    }
  }

  String get transactionDescription {
    if (accountSubGroup.isNotEmpty) {
      if (isDebit) {
        return 'The amount is auto-debited from your account and added to your Gold savings.';
      } else {
        return 'Amount credited to your account from $paymentMode.';
      }
    }

    if (isDebit) {
      return 'Amount debited via $paymentMode';
    } else {
      return 'Amount credited via $paymentMode';
    }
  }

  String get displayCategory {
    if (accountSubGroup.isNotEmpty) {
      return accountSubGroup
          .split(' ')
          .map((word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : word)
          .join(' ');
    }

    return paymentMode.toUpperCase();
  }

  Map<String, String> get monthYear {
    try {
      final date = DateTime.parse(transactionDate);
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

      return {
        'year': date.year.toString(),
        'month': months[date.month - 1],
      };
    } catch (e) {
      return {
        'year': 'Unknown',
        'month': 'Unknown',
      };
    }
  }

  @override
  String toString() {
    return 'TransactionApiModel('
        'amount: $formattedAmount, '
        'type: $transactionType, '
        'mode: $paymentMode, '
        'category: $displayCategory, '
        'date: $transactionDate'
        ')';
  }
}
