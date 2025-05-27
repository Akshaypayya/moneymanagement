import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:money_mangmnt/core/services/icon_mapping_service.dart';

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
  });

  factory GoalData.fromJson(Map<String, dynamic> json) {
    print('GOAL DETAIL PARSING: ${json['goalName']}');
    print('Available fields: ${json.keys.toList()}');
    print(
        'goalPic: ${json['goalPic'] != null ? "HAS_DATA(${json['goalPic'].toString().length} chars)" : "NULL"}');
    print('goalPicExtension: ${json['goalPicExtension']}');
    print('goalPicContentType: ${json['goalPicContentType']}');
    print('iconName: ${json['iconName']}');

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
    };
  }

  String get formattedTargetAmount => targetAmount.toStringAsFixed(2);
  String get formattedAvailableBalance => availableBalance.toStringAsFixed(2);
  String get formattedCurrentPrice => currentPrice.toStringAsFixed(2);
  String get formattedGoldBalance => goldBalance.toStringAsFixed(3);
  String get formattedWalletBalance => walletBalance.toStringAsFixed(2);
  String get formattedInvestedAmount => investedAmount.toStringAsFixed(2);
  double get profit => availableBalance - walletBalance;
  String get formattedProfit => profit.toStringAsFixed(2);

  double get progressPercent =>
      targetAmount > 0 ? (availableBalance / targetAmount) : 0.0;

  String get progressText {
    final totalMonths = duration * 12;
    final currentMonths =
        (availableBalance / (transactionAmount > 0 ? transactionAmount : 1))
            .round();
    return '$currentMonths/$totalMonths';
  }

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

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        print('  - ERROR loading asset $assetPath: $error');
        return Image.asset(
          'assets/customgoals.png',
          width: width,
          height: height,
        );
      },
    );
  }
}
