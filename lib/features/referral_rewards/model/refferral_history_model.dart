class RefferralHistoryModel {
  RefferralHistoryModel({
      this.data, 
      this.status,});

  RefferralHistoryModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }
  Data? data;
  String? status;
RefferralHistoryModel copyWith({  Data? data,
  String? status,
}) => RefferralHistoryModel(  data: data ?? this.data,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['status'] = status;
    return map;
  }

}

class Data {
  Data({
      this.totalReward, 
      this.referralHistory, 
      this.referralCode,});

  Data.fromJson(dynamic json) {
    totalReward = json['totalReward'];
    if (json['referralHistory'] != null) {
      referralHistory = [];
      json['referralHistory'].forEach((v) {
        referralHistory?.add(ReferralHistory.fromJson(v));
      });
    }
    referralCode = json['referralCode'];
  }
  String? totalReward;
  List<ReferralHistory>? referralHistory;
  String? referralCode;
Data copyWith({  String? totalReward,
  List<ReferralHistory>? referralHistory,
  String? referralCode,
}) => Data(  totalReward: totalReward ?? this.totalReward,
  referralHistory: referralHistory ?? this.referralHistory,
  referralCode: referralCode ?? this.referralCode,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['totalReward'] = totalReward;
    if (referralHistory != null) {
      map['referralHistory'] = referralHistory?.map((v) => v.toJson()).toList();
    }
    map['referralCode'] = referralCode;
    return map;
  }

}

class ReferralHistory {
  ReferralHistory({
      this.proPic, 
      this.proPicContentType, 
      this.appliedDate, 
      this.userName, 
      this.goldAmount,});

  ReferralHistory.fromJson(dynamic json) {
    proPic = json['proPic'];
    proPicContentType = json['proPicContentType'];
    appliedDate = json['appliedDate'];
    userName = json['userName'];
    goldAmount = json['goldAmount'];
  }
  dynamic proPic;
  dynamic proPicContentType;
  String? appliedDate;
  String? userName;
  num? goldAmount;
ReferralHistory copyWith({  dynamic proPic,
  dynamic proPicContentType,
  String? appliedDate,
  String? userName,
  num? goldAmount,
}) => ReferralHistory(  proPic: proPic ?? this.proPic,
  proPicContentType: proPicContentType ?? this.proPicContentType,
  appliedDate: appliedDate ?? this.appliedDate,
  userName: userName ?? this.userName,
  goldAmount: goldAmount ?? this.goldAmount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['proPic'] = proPic;
    map['proPicContentType'] = proPicContentType;
    map['appliedDate'] = appliedDate;
    map['userName'] = userName;
    map['goldAmount'] = goldAmount;
    return map;
  }

}