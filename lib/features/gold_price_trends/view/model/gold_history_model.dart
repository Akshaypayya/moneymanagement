class GoldHistoryModel {
  GoldHistoryModel({
      this.data, 
      this.status,});

  GoldHistoryModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }
  Data? data;
  String? status;
GoldHistoryModel copyWith({  Data? data,
  String? status,
}) => GoldHistoryModel(  data: data ?? this.data,
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
      this.change, 
      this.aaData, 
      this.highestBuyRate, 
      this.lowestBuyRate,});

  Data.fromJson(dynamic json) {
    change = json['change'];
    if (json['aaData'] != null) {
      aaData = [];
      json['aaData'].forEach((v) {
        aaData?.add(AaData.fromJson(v));
      });
    }
    highestBuyRate = json['highestBuyRate'];
    lowestBuyRate = json['lowestBuyRate'];
  }
  String? change;
  List<AaData>? aaData;
  num? highestBuyRate;
  num? lowestBuyRate;
Data copyWith({  String? change,
  List<AaData>? aaData,
  num? highestBuyRate,
  num? lowestBuyRate,
}) => Data(  change: change ?? this.change,
  aaData: aaData ?? this.aaData,
  highestBuyRate: highestBuyRate ?? this.highestBuyRate,
  lowestBuyRate: lowestBuyRate ?? this.lowestBuyRate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['change'] = change;
    if (aaData != null) {
      map['aaData'] = aaData?.map((v) => v.toJson()).toList();
    }
    map['highestBuyRate'] = highestBuyRate;
    map['lowestBuyRate'] = lowestBuyRate;
    return map;
  }

}

class AaData {
  AaData({
      this.buyRate, 
      this.rateTime,});

  AaData.fromJson(dynamic json) {
    buyRate = json['buyRate'];
    rateTime = json['rateTime'];
  }
  num? buyRate;
  String? rateTime;
AaData copyWith({  num? buyRate,
  String? rateTime,
}) => AaData(  buyRate: buyRate ?? this.buyRate,
  rateTime: rateTime ?? this.rateTime,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['buyRate'] = buyRate;
    map['rateTime'] = rateTime;
    return map;
  }

}