// To parse this JSON data, do
//
//     final modelLoginEmployee = modelLoginEmployeeFromJson(jsonString);

import 'dart:convert';

ModelLoginEmployee modelLoginEmployeeFromJson(String str) => ModelLoginEmployee.fromJson(json.decode(str));

String modelLoginEmployeeToJson(ModelLoginEmployee data) => json.encode(data.toJson());

class ModelLoginEmployee {
  bool? isSuccess;
  String? message;
  Data? data;

  ModelLoginEmployee({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelLoginEmployee.fromJson(Map<String, dynamic> json) => ModelLoginEmployee(
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
  int? branchId;

  Data({
    this.id,
    this.username,
    this.branchId,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    username: json["username"],
    branchId: json["branchId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "username": username,
    "branchId": branchId,
  };
}
