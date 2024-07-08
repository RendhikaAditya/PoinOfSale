// To parse this JSON data, do
//
//     final modelCrudProduct = modelCrudProductFromJson(jsonString);

import 'dart:convert';

ModelCrudProduct modelCrudProductFromJson(String str) => ModelCrudProduct.fromJson(json.decode(str));

String modelCrudProductToJson(ModelCrudProduct data) => json.encode(data.toJson());

class ModelCrudProduct {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelCrudProduct({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelCrudProduct.fromJson(Map<String, dynamic> json) => ModelCrudProduct(
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
  String? categoryId;
  String? branchId;
  String? name;
  String? description;
  String? price;
  String? stock;
  String? image;

  Datum({
    this.id,
    this.categoryId,
    this.branchId,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.image,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryId: json["category_id"],
    branchId: json["branch_id"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    stock: json["stock"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "branch_id": branchId,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "image": image,
  };
}
