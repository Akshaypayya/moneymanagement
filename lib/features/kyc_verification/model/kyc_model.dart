class KycModel {
  KycModel({
    this.data,
    this.status,
    this.message,
  });

  KycModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }

  Data? data;
  String? status;
  String? message;

  KycModel copyWith({
    Data? data,
    String? status,
    String? message,
  }) =>
      KycModel(
        data: data ?? this.data,
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
    this.idNumber,
  });

  Data.fromJson(dynamic json) {
    idNumber = json['idNumber'];
  }

  String? idNumber;

  Data copyWith({
    String? idNumber,
  }) =>
      Data(
        idNumber: idNumber ?? this.idNumber,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['idNumber'] = idNumber;
    return map;
  }
}
