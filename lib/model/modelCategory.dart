// To parse this JSON data, do
//
//     final modelCategory = modelCategoryFromJson(jsonString);

import 'dart:convert';

ModelCategory modelCategoryFromJson(String str) => ModelCategory.fromJson(json.decode(str));

String modelCategoryToJson(ModelCategory data) => json.encode(data.toJson());

class ModelCategory {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelCategory({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelCategory.fromJson(Map<String, dynamic> json) => ModelCategory(
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
  String? nameCategory;
  String? descriptionCategory;

  Datum({
    this.id,
    this.nameCategory,
    this.descriptionCategory,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    nameCategory: json["name_category"],
    descriptionCategory: json["description_category"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_category": nameCategory,
    "description_category": descriptionCategory,
  };
}
