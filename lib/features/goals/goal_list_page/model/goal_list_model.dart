import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:growk_v2/core/services/icon_mapping_service.dart';

class GoalListModel {
  final List<GoalListItem> data;
  final String status;
  final String? message;

  GoalListModel({
    required this.data,
    required this.status,
    this.message,
  });

  factory GoalListModel.fromJson(Map<String, dynamic> json) {
    return GoalListModel(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((item) => GoalListItem.fromJson(item))
              .toList()
          : [],
      status: json['status'] ?? '',
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'status': status,
      'message': message,
    };
  }

  bool get isSuccess => status == 'Success';
}

class GoalListItem {
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
  final String status;

  GoalListItem({
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
    required this.status,
  });

  factory GoalListItem.fromJson(Map<String, dynamic> json) {
    print('PARSING GOAL: ${json['goalName']}');
    print('Available fields: ${json.keys.toList()}');
    print(
        'goalPic: ${json['goalPic'] != null ? "HAS_DATA(${json['goalPic'].toString().length} chars)" : "NULL"}');
    print('goalPicExtension: ${json['goalPicExtension']}');
    print('goalPicContentType: ${json['goalPicContentType']}');
    print('iconName: ${json['iconName']}');
    print('createdDate: ${json['createdDate']}');
    print('availableBalance: ${json['availableBalance']}');
    print('buyPrice: ${json['buyPrice']}');
    print('currentPrice: ${json['currentPrice']}');
    print('goldBalance: ${json['goldBalance']}');
    print('walletBalance: ${json['walletBalance']}');
    print('linkedVA: ${json['linkedVA']}');
    print('investedAmount: ${json['investedAmount']}');
    print('goal status: ${json['status']}');

    return GoalListItem(
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
      status: json['status'] ?? '',
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
      'status': status,
    };
  }

  String get formattedTargetAmount => targetAmount.toStringAsFixed(2);
  String get formattedAvailableBalance => availableBalance.toStringAsFixed(2);
  String get formattedCurrentPrice => currentPrice.toStringAsFixed(2);
  String get formattedGoldBalance => goldBalance.toStringAsFixed(2);
  String get formattedWalletBalance => walletBalance.toStringAsFixed(2);

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

  String get iconAsset {
    print('ICON ASSET for goal: $goalName');
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

  Widget _buildAssetIcon(double width, double height) {
    final assetPath = iconAsset;
    print('  - Building asset icon: $assetPath');

    return ClipOval(
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          print('  - ERROR loading asset $assetPath: $error');
          return Image.asset(
            'assets/customgoals.png',
            width: width,
            height: height,
            fit: BoxFit.contain,
          );
        },
      ),
    );
  }

  Widget getIconWidget({double width = 60, double height = 60}) {
    print('GOAL LIST GET ICON WIDGET for: $goalName');
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

  Widget _getFallbackIcon(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/customgoals.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
