// To parse this JSON data, do
//
//     final modelProduct = modelProductFromJson(jsonString);

import 'dart:convert';

ModelProduct modelProductFromJson(String str) => ModelProduct.fromJson(json.decode(str));

String modelProductToJson(ModelProduct data) => json.encode(data.toJson());

class ModelProduct {
  bool? isSuccess;
  String? message;
  List<Datum>? data;
  int? totalQty;
  int? totalPrice;

  ModelProduct({
    this.isSuccess,
    this.message,
    this.data,
    this.totalQty,
    this.totalPrice,
  });

  factory ModelProduct.fromJson(Map<String, dynamic> json) => ModelProduct(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    totalQty: json["total_qty"],
    totalPrice: json["total_price"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    "total_qty": totalQty,
    "total_price": totalPrice,
  };
}

class Datum {
  int? id;
  String? name;
  String? description;
  int? price;
  int? stock;
  String? image;
  String? nameCategory;
  String? descriptionCategory;
  int? qty;

  Datum({
    this.id,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.image,
    this.nameCategory,
    this.descriptionCategory,
    this.qty,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    image: json["image"],
    nameCategory: json["name_category"],
    descriptionCategory: json["description_category"],
    qty: json["qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "image": image,
    "name_category": nameCategory,
    "description_category": descriptionCategory,
    "qty": qty,
  };
}
