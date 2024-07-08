// To parse this JSON data, do
//
//     final modelCartManual = modelCartManualFromJson(jsonString);

import 'dart:convert';

ModelCartManual modelCartManualFromJson(String str) => ModelCartManual.fromJson(json.decode(str));

String modelCartManualToJson(ModelCartManual data) => json.encode(data.toJson());

class ModelCartManual {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelCartManual({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelCartManual.fromJson(Map<String, dynamic> json) => ModelCartManual(
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
  String? employeId;
  String? productId;
  String? price;
  String? qty;

  Datum({
    this.id,
    this.employeId,
    this.productId,
    this.price,
    this.qty,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    employeId: json["employe_id"],
    productId: json["product_id"],
    price: json["price"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employe_id": employeId,
    "product_id": productId,
    "price": price,
    "qty": qty,
  };
}
