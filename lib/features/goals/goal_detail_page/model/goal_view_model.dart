import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

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
  final String createdDate;
  final double availableBalance;
  final double buyPrice;
  final double currentPrice;
  final double goldBalance;
  final double walletBalance;
  final String linkedVA;

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
    required this.createdDate,
    required this.availableBalance,
    required this.buyPrice,
    required this.currentPrice,
    required this.goldBalance,
    required this.walletBalance,
    required this.linkedVA,
  });

  factory GoalData.fromJson(Map<String, dynamic> json) {
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
      goalPicContentType: json['goalPicContentType'], // Parse new field
      createdDate: json['createdDate'] ?? '',
      availableBalance: (json['availableBalance'] ?? 0).toDouble(),
      buyPrice: (json['buyPrice'] ?? 0).toDouble(),
      currentPrice: (json['currentPrice'] ?? 0).toDouble(),
      goldBalance: (json['goldBalance'] ?? 0).toDouble(),
      walletBalance: (json['walletBalance'] ?? 0).toDouble(),
      linkedVA: json['linkedVA'] ?? '',
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
      'createdDate': createdDate,
      'availableBalance': availableBalance,
      'buyPrice': buyPrice,
      'currentPrice': currentPrice,
      'goldBalance': goldBalance,
      'walletBalance': walletBalance,
      'linkedVA': linkedVA,
    };
  }

  String get formattedTargetAmount => targetAmount.toStringAsFixed(2);
  String get formattedAvailableBalance => availableBalance.toStringAsFixed(2);
  String get formattedCurrentPrice => currentPrice.toStringAsFixed(2);
  String get formattedGoldBalance => goldBalance.toStringAsFixed(3);
  String get formattedWalletBalance => walletBalance.toStringAsFixed(2);

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
    if (goalPicContentType != null && (goalPic == null || goalPic!.isEmpty)) {
      if (goalPicExtension != null && goalPicExtension!.isNotEmpty) {
        final ext = goalPicExtension!.toLowerCase();
        if (ext.contains('home')) return 'assets/home.png';
        if (ext.contains('education')) return 'assets/education.png';
        if (ext.contains('wedding')) return 'assets/wedding.png';
        if (ext.contains('trip')) return 'assets/trip.png';
      }
    }

    final lowercaseName = goalName.toLowerCase();

    if (lowercaseName.contains('home') || lowercaseName.contains('house')) {
      return 'assets/home.png';
    } else if (lowercaseName.contains('education') ||
        lowercaseName.contains('study')) {
      return 'assets/education.png';
    } else if (lowercaseName.contains('wedding') ||
        lowercaseName.contains('marriage')) {
      return 'assets/wedding.png';
    } else if (lowercaseName.contains('trip') ||
        lowercaseName.contains('travel')) {
      return 'assets/trip.png';
    } else {
      return 'assets/customgoals.png';
    }
  }

  Widget getIconWidget({double width = 60, double height = 60}) {
    if (goalPic != null && goalPic!.isNotEmpty) {
      try {
        final bytes = base64Decode(goalPic!);
        return ClipOval(
          child: Image.memory(
            bytes,
            width: width,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Error loading goal image: $error');
              return Image.asset(
                iconAsset,
                width: width,
                height: height,
              );
            },
          ),
        );
      } catch (e) {
        debugPrint('Error decoding goal image: $e');
        return Image.asset(
          iconAsset,
          width: width,
          height: height,
        );
      }
    } else {
      return Image.asset(
        iconAsset,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading asset image: $error');
          return Image.asset(
            'assets/customgoals.png',
            width: width,
            height: height,
          );
        },
      );
    }
  }
}
