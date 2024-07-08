// To parse this JSON data, do
//
//     final modelLoginOwner = modelLoginOwnerFromJson(jsonString);

import 'dart:convert';

ModelLoginOwner modelLoginOwnerFromJson(String str) => ModelLoginOwner.fromJson(json.decode(str));

String modelLoginOwnerToJson(ModelLoginOwner data) => json.encode(data.toJson());

class ModelLoginOwner {
  bool? isSuccess;
  String? message;
  Data? data;

  ModelLoginOwner({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelLoginOwner.fromJson(Map<String, dynamic> json) => ModelLoginOwner(
    isSuccess: json["isSuccess"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "isSuccess": isSuccess,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int? id;
  String? username;

  Data({
    this.id,
    this.username,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
  };
}
