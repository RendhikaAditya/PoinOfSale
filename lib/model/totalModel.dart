// To parse this JSON data, do
//
//     final modelTotal = modelTotalFromJson(jsonString);

import 'dart:convert';

ModelTotal modelTotalFromJson(String str) => ModelTotal.fromJson(json.decode(str));

String modelTotalToJson(ModelTotal data) => json.encode(data.toJson());

class ModelTotal {
  bool? isSuccess;
  String? message;
  int? totalQty;
  int? totalPrice;

  ModelTotal({
    this.isSuccess,
    this.message,
    this.totalQty,
    this.totalPrice,
  });

  factory ModelTotal.fromJson(Map<String, dynamic> json) => ModelTotal(
    isSuccess: json["isSuccess"],
    message: json["message"],
    totalQty: json["total_qty"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "total_qty": totalQty,
    "total_price": totalPrice,
  };
}
