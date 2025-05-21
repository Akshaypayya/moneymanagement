class SavedAdddressModel {
  SavedAdddressModel({
      this.data, 
      this.status, 
      this.message,});

  SavedAdddressModel.fromJson(dynamic json) {
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    status = json['status'];
    message = json['message'];
  }
  Data? data;
  String? status;
  String? message;
SavedAdddressModel copyWith({  Data? data,
  String? status,
  String? message,
}) => SavedAdddressModel(  data: data ?? this.data,
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
      this.city, 
      this.pinCode, 
      this.streetAddress1, 
      this.streetAddress2, 
      this.state,});

  Data.fromJson(dynamic json) {
    city = json['city'];
    pinCode = json['pinCode'];
    streetAddress1 = json['streetAddress1'];
    streetAddress2 = json['streetAddress2'];
    state = json['state'];
  }
  String? city;
  String? pinCode;
  String? streetAddress1;
  String? streetAddress2;
  String? state;
Data copyWith({  String? city,
  String? pinCode,
  String? streetAddress1,
  String? streetAddress2,
  String? state,
}) => Data(  city: city ?? this.city,
  pinCode: pinCode ?? this.pinCode,
  streetAddress1: streetAddress1 ?? this.streetAddress1,
  streetAddress2: streetAddress2 ?? this.streetAddress2,
  state: state ?? this.state,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['city'] = city;
    map['pinCode'] = pinCode;
    map['streetAddress1'] = streetAddress1;
    map['streetAddress2'] = streetAddress2;
    map['state'] = state;
    return map;
  }

}