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

  ModelProduct({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelProduct.fromJson(Map<String, dynamic> json) => ModelProduct(
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
  String? idProduct;
  String? idBranch;
  String? categoryId;
  String? branchId;
  String? name;
  String? description;
  String? price;
  String? stock;
  String? image;

  Datum({
    this.id,
    this.idProduct,
    this.idBranch,
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
    idProduct: json["id_product"],
    idBranch: json["id_branch"],
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
    "id_product": idProduct,
    "id_branch": idBranch,
    "category_id": categoryId,
    "branch_id": branchId,
    "name": name,
    "description": description,
    "price": price,
    "stock": stock,
    "image": image,
  };
}
