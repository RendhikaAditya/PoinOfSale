// To parse this JSON data, do
//
//     final modelCustomer = modelCustomerFromJson(jsonString);

import 'dart:convert';

ModelCustomer modelCustomerFromJson(String str) => ModelCustomer.fromJson(json.decode(str));

String modelCustomerToJson(ModelCustomer data) => json.encode(data.toJson());

class ModelCustomer {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelCustomer({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelCustomer.fromJson(Map<String, dynamic> json) => ModelCustomer(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  String? id;
  String? customersName;
  String? phoneNumber;
  String? customersEmail;
  String? customersAddress;

  Datum({
    this.id,
    this.customersName,
    this.phoneNumber,
    this.customersEmail,
    this.customersAddress,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    customersName: json["customers_name"],
    phoneNumber: json["phone_number"],
    customersEmail: json["customers_email"],
    customersAddress: json["customers_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customers_name": customersName,
    "phone_number": phoneNumber,
    "customers_email": customersEmail,
    "customers_address": customersAddress,
  };
}
