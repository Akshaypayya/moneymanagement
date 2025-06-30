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
      totalRecords = (json['iTotalRecords'] as num?)?.toInt() ?? 0;
    }

    if (json.containsKey('iTotalDisplayRecords')) {
      displayRecords = (json['iTotalDisplayRecords'] as num?)?.toInt() ?? 0;
    }

    if (json.containsKey('aaData') && json['aaData'] is List) {
      final aaDataList = json['aaData'] as List;
      debugPrint(
          'PARSING: Found ${aaDataList.length} transactions in aaData array');

      try {
        transactions = aaDataList
            .map((item) =>
                TransactionApiModel.fromJson(item as Map<String, dynamic>))
            .toList();
        debugPrint(
            'PARSING: Successfully parsed ${transactions.length} transaction models');
      } catch (e) {
        debugPrint('PARSING ERROR: Failed to parse transactions: $e');
        debugPrint(
            'PARSING ERROR: Sample item: ${aaDataList.isNotEmpty ? aaDataList.first : 'EMPTY'}');
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
  final String accountSubGroup;
  final String transactionCode;
  final double? chargeAmount;
  final double? vatAmount;

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
        amount: _parseDouble(json['amount']) ?? 0.0,
        operationPrice: _parseDouble(json['operationPrice']),
        paymentMode: json['paymentMode']?.toString() ?? 'Unknown',
        bankReference: json['bankReference']?.toString() ?? '',
        currencyCode: json['currencyCode']?.toString() ?? 'SAR',
        operationCurrencyCode:
            json['operationCurrencyCode']?.toString() ?? 'SAR',
        transactionDate: json['transactionDate']?.toString() ??
            DateTime.now().toIso8601String(),
        drcrFlag: _parseInt(json['drcrFlag']) ?? 0,
        sequence: _parseInt(json['sequence']) ?? 0,
        accountGroup: json['accountGroup']?.toString(),
        accountSubGroup: json['accountSubGroup']?.toString() ?? '',
        transactionCode: json['transactionCode']?.toString() ?? '',
        chargeAmount: _parseDouble(json['chargeAmount']),
        vatAmount: _parseDouble(json['vatAmount']),
      );
    } catch (e) {
      debugPrint('PARSING ERROR for TransactionApiModel: $e');
      debugPrint('PARSING ERROR JSON: $json');
      rethrow;
    }
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.round();
    if (value is String) {
      return int.tryParse(value);
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
      return amount.toStringAsFixed(2).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    } catch (e) {
      return '0.00';
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

  String get transactionType {
    if (isCredit) {
      return currencyCode == 'XAU' ? 'Gold Purchase' : 'Credit';
    } else if (isDebit) {
      int flagToUse = drcrFlag == 0 ? sequence : drcrFlag;
      switch (flagToUse) {
        case 2:
          return 'Debit';
        case 3:
          return 'Transaction Charge';
        case 4:
          return 'VAT Charge';
        default:
          return 'Debit';
      }
    }
    return 'Transaction';
  }

  String get signedFormattedAmount {
    String baseAmount = formattedAmount;

    if (isDebit) {
      return '-$baseAmount';
    } else if (isCredit) {
      return '+$baseAmount';
    }

    return baseAmount;
  }

  String get goalBasedIcon {
    final subGroup = accountSubGroup.toLowerCase();

    if (subGroup.contains('education') || subGroup.contains('study')) {
      return 'assets/education.jpg';
    } else if (subGroup.contains('home') || subGroup.contains('house')) {
      // return 'assets/home.png';
      return 'assets/home.jpg';
    } else if (subGroup.contains('wedding') || subGroup.contains('marriage')) {
      return 'assets/wedding.jpg';
    } else if (subGroup.contains('trip') || subGroup.contains('travel')) {
      return 'assets/trip.jpg';
    } else {
      return transactionIcon;
    }
  }

  String get transactionIcon {
    if (isCredit && currencyCode == 'XAU') {
      return 'assets/goldbsct.png';
    }

    switch (paymentMode.toLowerCase()) {
      case 'bank transfer':
        return 'assets/bank.jpg';
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
      if (isCredit) {
        if (currencyCode == 'XAU') {
          return 'Gold credited to your goal \"$accountSubGroup\". Amount auto-debited from your account.';
        } else {
          return 'Amount deposited to your goal \"$accountSubGroup\" savings.';
        }
      } else if (isDebit) {
        int flagToUse = drcrFlag == 0 ? sequence : drcrFlag;
        switch (flagToUse) {
          case 2:
            return currencyCode == 'XAU'
                ? 'Gold withdrawn from your goal \"$accountSubGroup\".'
                : 'Amount withdrawn from your goal \"$accountSubGroup\".';
          case 3:
            return 'Transaction charges applied to your goal \"$accountSubGroup\".';
          case 4:
            return 'VAT charges applied to your goal \"$accountSubGroup\".';
          default:
            return currencyCode == 'XAU'
                ? 'Gold debited from your goal \"$accountSubGroup\".'
                : 'Amount debited from your goal \"$accountSubGroup\".';
        }
      }
    }

    if (isCredit) {
      return currencyCode == 'XAU'
          ? 'Gold credited'
          : 'Amount credited via $paymentMode';
    } else if (isDebit) {
      return currencyCode == 'XAU'
          ? 'Gold debited'
          : 'Amount debited via $paymentMode';
    }

    return currencyCode == 'XAU'
        ? 'Gold transaction processed via $paymentMode'
        : 'Transaction processed via $paymentMode';
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

  String get debugInfo {
    return 'drcrFlag: $drcrFlag, sequence: $sequence, type: $transactionType, isCredit: $isCredit, isDebit: $isDebit';
  }

  @override
  String toString() {
    return 'TransactionApiModel('
        'amount: $formattedAmount, '
        'type: $transactionType, '
        'mode: $paymentMode, '
        'category: $displayCategory, '
        'date: $transactionDate, '
        'debug: $debugInfo'
        ')';
  }
}
