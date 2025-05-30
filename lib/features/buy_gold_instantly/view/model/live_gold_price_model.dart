class LiveGoldPriceModel {
  LiveGoldPriceModel({
      this.data, 
      this.status,});

  LiveGoldPriceModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
  }
  Data? data;
  String? status;
LiveGoldPriceModel copyWith({  Data? data,
  String? status,
}) => LiveGoldPriceModel(  data: data ?? this.data,
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
      this.sellRate, 
      this.curCode, 
      this.buyRate,});

  Data.fromJson(dynamic json) {
    sellRate = json['sellRate'];
    curCode = json['curCode'];
    buyRate = json['buyRate'];
  }
  num? sellRate;
  String? curCode;
  num? buyRate;
Data copyWith({  num? sellRate,
  String? curCode,
  num? buyRate,
}) => Data(  sellRate: sellRate ?? this.sellRate,
  curCode: curCode ?? this.curCode,
  buyRate: buyRate ?? this.buyRate,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sellRate'] = sellRate;
    map['curCode'] = curCode;
    map['buyRate'] = buyRate;
    return map;
  }

}