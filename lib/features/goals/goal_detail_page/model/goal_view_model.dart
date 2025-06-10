import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:growk_v2/core/services/icon_mapping_service.dart';

class GoalViewModel {
  final GoalData? data;
  final String status;

  GoalViewModel({
    this.data,
    required this.status,
  });

  factory GoalViewModel.fromJson(Map<String, dynamic> json) {
    return GoalViewModel(
      data: json['data'] != null ? GoalData.fromJson(json['data']) : null,
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

class GoalData {
  final String goalName;
  final int targetYear;
  final double targetAmount;
  final int duration;
  final int debitDate;
  final double transactionAmount;
  final String goldInvestment;
  final String? goalPic;
  final String? goalPicExtension;
  final String? goalPicContentType;
  final String? iconName;
  final String createdDate;
  final double availableBalance;
  final double buyPrice;
  final double currentPrice;
  final double goldBalance;
  final double walletBalance;
  final String linkedVA;
  final double investedAmount;
  final String? bankId;
  final String? accountName;
  final String? status;

  GoalData({
    required this.goalName,
    required this.targetYear,
    required this.targetAmount,
    required this.duration,
    required this.debitDate,
    required this.transactionAmount,
    required this.goldInvestment,
    this.goalPic,
    this.goalPicExtension,
    this.goalPicContentType,
    this.iconName,
    required this.createdDate,
    required this.availableBalance,
    required this.buyPrice,
    required this.currentPrice,
    required this.goldBalance,
    required this.walletBalance,
    required this.linkedVA,
    required this.investedAmount,
    this.bankId,
    this.accountName,
    this.status,
  });

  factory GoalData.fromJson(Map<String, dynamic> json) {
    print('GOAL DETAIL PARSING: ${json['goalName']}');
    print('Available fields: ${json.keys.toList()}');
    print(
        'goalPic: ${json['goalPic'] != null ? "HAS_DATA(${json['goalPic'].toString().length} chars)" : "NULL"}');
    print('goalPicExtension: ${json['goalPicExtension']}');
    print('goalPicContentType: ${json['goalPicContentType']}');
    print('iconName: ${json['iconName']}');
    print('bankId: ${json['bankId']}');
    print('accountName: ${json['accountName']}');
    print('status: ${json['status']}');

    return GoalData(
      goalName: json['goalName'] ?? '',
      targetYear: json['targetYear'] ?? 0,
      targetAmount: (json['targetAmount'] ?? 0).toDouble(),
      duration: json['duration'] ?? 0,
      debitDate: json['debitDate'] ?? 0,
      transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
      goldInvestment: json['goldInvestment'] ?? '',
      goalPic: json['goalPic'],
      goalPicExtension: json['goalPicExtension'],
      goalPicContentType: json['goalPicContentType'],
      iconName: json['iconName'],
      createdDate: json['createdDate'] ?? '',
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
      buyPrice: (json['buyPrice'] ?? 0).toDouble(),
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      goldBalance: (json['goldBalance'] ?? 0).toDouble(),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      linkedVA: json['linkedVA'] ?? '',
      investedAmount: (json['investedAmount'] ?? 0).toDouble(),
      bankId: json['bankId'],
      accountName: json['accountName'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'goalName': goalName,
      'targetYear': targetYear,
      'targetAmount': targetAmount,
      'duration': duration,
      'debitDate': debitDate,
      'transactionAmount': transactionAmount,
      'goldInvestment': goldInvestment,
      'goalPic': goalPic,
      'goalPicExtension': goalPicExtension,
      'goalPicContentType': goalPicContentType,
      'iconName': iconName,
      'createdDate': createdDate,
      'availableBalance': availableBalance,
      'buyPrice': buyPrice,
      'currentPrice': currentPrice,
      'goldBalance': goldBalance,
      'walletBalance': walletBalance,
      'linkedVA': linkedVA,
      'investedAmount': investedAmount,
      'bankId': bankId,
      'accountName': accountName,
      'status': status,
    };
  }

  String get formattedTargetAmount => targetAmount.toStringAsFixed(2);
  String get formattedAvailableBalance => availableBalance.toStringAsFixed(2);
  String get formattedCurrentPrice => currentPrice.toStringAsFixed(2);
  String get formattedGoldBalance => goldBalance.toStringAsFixed(2);
  String get formattedWalletBalance => walletBalance.toStringAsFixed(2);
  String get formattedInvestedAmount => investedAmount.toStringAsFixed(2);
  double get profit => availableBalance - walletBalance;
  String get formattedProfit => profit.toStringAsFixed(2);

  int get totalExpectedTransactions {
    final totalMonths = duration * 12;

    switch (debitDate) {
      case 1:
        return totalMonths * 30;
      case 7:
        return totalMonths * 4;
      case 5:
      default:
        return totalMonths;
    }
  }

  int get currentCompletedTransactions {
    if (transactionAmount <= 0) return 0;
    return (investedAmount / transactionAmount).round();
  }

  String get progressText {
    return '$currentCompletedTransactions/$totalExpectedTransactions';
  }

  double get progressPercent {
    if (totalExpectedTransactions <= 0) return 0.0;
    return (currentCompletedTransactions / totalExpectedTransactions)
        .clamp(0.0, 1.0);
  }

  double get progressValue => availableBalance - investedAmount;

  String get formattedProgressValue => progressValue.toStringAsFixed(2);

  String get frequencyText {
    switch (debitDate) {
      case 1:
        return 'Daily';
      case 7:
        return 'Weekly';
      case 5:
      default:
        return 'Monthly';
    }
  }

  String get bankName => bankId ?? 'Arab National Bank';
  String get accountHolderName => accountName ?? 'Nexus Global Limited';

  String get iconAsset {
    print('GOAL DETAIL ICON ASSET for: $goalName');
    print('  - iconName: $iconName');
    print('  - goalPicContentType: $goalPicContentType');
    print('  - has goalPic: ${goalPic != null && goalPic!.isNotEmpty}');

    if (iconName != null && iconName!.isNotEmpty) {
      final assetPath = 'assets/$iconName';
      print('  - Using iconName: $assetPath');
      return assetPath;
    }

    if (goalPicContentType != null &&
        goalPicContentType!.isNotEmpty &&
        (goalPic == null || goalPic!.isEmpty)) {
      print('  - Preset icon detected but no iconName field');
      final storedIcon = IconMappingService.getStoredIcon(goalName);
      if (storedIcon != null) {
        final assetPath = 'assets/$storedIcon';
        print('  - Using stored icon: $assetPath');
        return assetPath;
      }
    }

    print('  - Using default icon: assets/customgoals.png');
    return 'assets/customgoals.png';
  }

  Widget getIconWidget({double width = 60, double height = 60}) {
    print('GOAL DETAIL GET ICON WIDGET for: $goalName');
    print('  - Has goalPic: ${goalPic != null && goalPic!.isNotEmpty}');
    print('  - iconName: $iconName');
    print('  - goalPicContentType: $goalPicContentType');

    if (goalPic != null && goalPic!.isNotEmpty) {
      print('  - Using base64 image from goalPic');
      try {
        final bytes = base64Decode(goalPic!);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              print('  - ERROR loading base64 image: $error');
              return _buildAssetIcon(width, height);
            },
          ),
        );
      } catch (e) {
        print('  - ERROR decoding base64: $e');
        return _buildAssetIcon(width, height);
      }
    }

    print('  - Using asset icon');
    return _buildAssetIcon(width, height);
  }

  Widget _buildAssetIcon(double width, double height) {
    final assetPath = iconAsset;
    print('  - Building asset icon: $assetPath');

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Image.asset(
          assetPath,
          width: width - 12,
          height: height - 12,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('  - ERROR loading asset $assetPath: $error');
            return Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/customgoals.png',
                width: width - 12,
                height: height - 12,
                fit: BoxFit.contain,
              ),
            );
          },
        ),
      ),
    );
  }
}
