class InitiateBuyGoldModel {
  InitiateBuyGoldModel({
      this.data, 
      this.status, 
      this.message,});

  InitiateBuyGoldModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }
  Data? data;
  String? status;
  String? message;
InitiateBuyGoldModel copyWith({  Data? data,
  String? status,
  String? message,
}) => InitiateBuyGoldModel(  data: data ?? this.data,
  status: status ?? this.status,
  message: message ?? this.message,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['status'] = status;
    map['message'] = message;
    return map;
  }

}

class Data {
  Data({
      this.transactionAmount, 
      this.chargeAmount, 
      this.transactionId, 
      this.vATamount,});

  Data.fromJson(dynamic json) {
    transactionAmount = json['transactionAmount'];
    chargeAmount = json['ChargeAmount'];
    transactionId = json['transactionId'];
    vATamount = json['VATamount'];
  }
  num? transactionAmount;
  num? chargeAmount;
  String? transactionId;
  num? vATamount;
Data copyWith({  num? transactionAmount,
  num? chargeAmount,
  String? transactionId,
  num? vATamount,
}) => Data(  transactionAmount: transactionAmount ?? this.transactionAmount,
  chargeAmount: chargeAmount ?? this.chargeAmount,
  transactionId: transactionId ?? this.transactionId,
  vATamount: vATamount ?? this.vATamount,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['transactionAmount'] = transactionAmount;
    map['ChargeAmount'] = chargeAmount;
    map['transactionId'] = transactionId;
    map['VATamount'] = vATamount;
    return map;
  }

}