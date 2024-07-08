// To parse this JSON data, do
//
//     final modelBase = modelBaseFromJson(jsonString);

import 'dart:convert';

ModelBase modelBaseFromJson(String str) => ModelBase.fromJson(json.decode(str));

String modelBaseToJson(ModelBase data) => json.encode(data.toJson());

class ModelBase {
  bool? isSuccess;
  String? message;

  ModelBase({
    this.isSuccess,
    this.message,
  });

  factory ModelBase.fromJson(Map<String, dynamic> json) => ModelBase(
    isSuccess: json["isSuccess"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
  };
}
