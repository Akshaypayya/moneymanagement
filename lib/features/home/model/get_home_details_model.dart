class GetHomeDetailsModel {
  GetHomeDetailsModel({
    this.data,
    this.status,
    this.message,
  });

  Data? data;
  String? status;
  String? message; // 🆕 Added

  GetHomeDetailsModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message']; // 🆕 Added
  }

  GetHomeDetailsModel copyWith({
    Data? data,
    String? status,
    String? message,
  }) =>
      GetHomeDetailsModel(
        data: data ?? this.data,
        status: status ?? this.status,
        message: message ?? this.message, // 🆕 Added
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['status'] = status;
    map['message'] = message; // 🆕 Added
    return map;
  }
}


class Data {
  Data({
      this.summary, 
      this.wallet, 
      this.referral, 
      this.goals,});

  Data.fromJson(dynamic json) {
    summary = json['summary'] != null ? Summary.fromJson(json['summary']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    referral = json['referral'] != null ? Referral.fromJson(json['referral']) : null;
    goals = json['goals'] != null ? Goals.fromJson(json['goals']) : null;
  }
  Summary? summary;
  Wallet? wallet;
  Referral? referral;
  Goals? goals;
Data copyWith({  Summary? summary,
  Wallet? wallet,
  Referral? referral,
  Goals? goals,
}) => Data(  summary: summary ?? this.summary,
  wallet: wallet ?? this.wallet,
  referral: referral ?? this.referral,
  goals: goals ?? this.goals,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (summary != null) {
      map['summary'] = summary?.toJson();
    }
    if (wallet != null) {
      map['wallet'] = wallet?.toJson();
    }
    if (referral != null) {
      map['referral'] = referral?.toJson();
    }
    if (goals != null) {
      map['goals'] = goals?.toJson();
    }
    return map;
  }

}

class Goals {
  Goals({
      this.buyPrice, 
      this.walletBalance, 
      this.totalBalance, 
      this.totalInvested, 
      this.currentPrice, 
      this.goldBalance,});

  Goals.fromJson(dynamic json) {
    buyPrice = json['buyPrice'];
    walletBalance = json['walletBalance'];
    totalBalance = json['totalBalance'];
    totalInvested = json['totalInvested'];
    currentPrice = json['currentPrice'];
    goldBalance = json['goldBalance'];
  }
  num? buyPrice;
  num? walletBalance;
  num? totalBalance;
  num? totalInvested;
  num? currentPrice;
  num? goldBalance;
Goals copyWith({  num? buyPrice,
  num? walletBalance,
  num? totalBalance,
  num? totalInvested,
  num? currentPrice,
  num? goldBalance,
}) => Goals(  buyPrice: buyPrice ?? this.buyPrice,
  walletBalance: walletBalance ?? this.walletBalance,
  totalBalance: totalBalance ?? this.totalBalance,
  totalInvested: totalInvested ?? this.totalInvested,
  currentPrice: currentPrice ?? this.currentPrice,
  goldBalance: goldBalance ?? this.goldBalance,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['buyPrice'] = buyPrice;
    map['walletBalance'] = walletBalance;
    map['totalBalance'] = totalBalance;
    map['totalInvested'] = totalInvested;
    map['currentPrice'] = currentPrice;
    map['goldBalance'] = goldBalance;
    return map;
  }

}

class Referral {
  Referral({
      this.buyPrice, 
      this.currentPrice, 
      this.goldBalance,});

  Referral.fromJson(dynamic json) {
    buyPrice = json['buyPrice'];
    currentPrice = json['currentPrice'];
    goldBalance = json['goldBalance'];
  }
  num? buyPrice;
  num? currentPrice;
  num? goldBalance;
Referral copyWith({  num? buyPrice,
  num? currentPrice,
  num? goldBalance,
}) => Referral(  buyPrice: buyPrice ?? this.buyPrice,
  currentPrice: currentPrice ?? this.currentPrice,
  goldBalance: goldBalance ?? this.goldBalance,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['buyPrice'] = buyPrice;
    map['currentPrice'] = currentPrice;
    map['goldBalance'] = goldBalance;
    return map;
  }

}

class Wallet {
  Wallet({
      this.buyPrice, 
      this.walletBalance, 
      this.totalBalance, 
      this.currentPrice, 
      this.goldBalance,});

  Wallet.fromJson(dynamic json) {
    buyPrice = json['buyPrice'];
    walletBalance = json['walletBalance'];
    totalBalance = json['totalBalance'];
    currentPrice = json['currentPrice'];
    goldBalance = json['goldBalance'];
  }
  num? buyPrice;
  num? walletBalance;
  num? totalBalance;
  num? currentPrice;
  num? goldBalance;
Wallet copyWith({  num? buyPrice,
  num? walletBalance,
  num? totalBalance,
  num? currentPrice,
  num? goldBalance,
}) => Wallet(  buyPrice: buyPrice ?? this.buyPrice,
  walletBalance: walletBalance ?? this.walletBalance,
  totalBalance: totalBalance ?? this.totalBalance,
  currentPrice: currentPrice ?? this.currentPrice,
  goldBalance: goldBalance ?? this.goldBalance,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['buyPrice'] = buyPrice;
    map['walletBalance'] = walletBalance;
    map['totalBalance'] = totalBalance;
    map['currentPrice'] = currentPrice;
    map['goldBalance'] = goldBalance;
    return map;
  }

}

class Summary {
  Summary({
      this.buyPrice, 
      this.walletBalance, 
      this.totalBalance, 
      this.currentPrice, 
      this.goldBalance,});

  Summary.fromJson(dynamic json) {
    buyPrice = json['buyPrice'];
    walletBalance = json['walletBalance'];
    totalBalance = json['totalBalance'];
    currentPrice = json['currentPrice'];
    goldBalance = json['goldBalance'];
  }
  num? buyPrice;
  num? walletBalance;
  num? totalBalance;
  num? currentPrice;
  num? goldBalance;
Summary copyWith({  num? buyPrice,
  num? walletBalance,
  num? totalBalance,
  num? currentPrice,
  num? goldBalance,
}) => Summary(  buyPrice: buyPrice ?? this.buyPrice,
  walletBalance: walletBalance ?? this.walletBalance,
  totalBalance: totalBalance ?? this.totalBalance,
  currentPrice: currentPrice ?? this.currentPrice,
  goldBalance: goldBalance ?? this.goldBalance,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['buyPrice'] = buyPrice;
    map['walletBalance'] = walletBalance;
    map['totalBalance'] = totalBalance;
    map['currentPrice'] = currentPrice;
    map['goldBalance'] = goldBalance;
    return map;
  }

}