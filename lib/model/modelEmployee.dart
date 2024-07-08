// To parse this JSON data, do
//
//     final modelEmployee = modelEmployeeFromJson(jsonString);

import 'dart:convert';

ModelEmployee modelEmployeeFromJson(String str) => ModelEmployee.fromJson(json.decode(str));

String modelEmployeeToJson(ModelEmployee data) => json.encode(data.toJson());

class ModelEmployee {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelEmployee({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelEmployee.fromJson(Map<String, dynamic> json) => ModelEmployee(
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
  String? branchId;
  String? username;
  String? password;
  String? role;
  String? branchName;
  String? branchAddress;

  Datum({
    this.id,
    this.branchId,
    this.username,
    this.password,
    this.role,
    this.branchName,
    this.branchAddress,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    branchId: json["branch_id"],
    username: json["username"],
    password: json["password"],
    role: json["role"],
    branchName: json["branch_name"],
    branchAddress: json["branch_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_id": branchId,
    "username": username,
    "password": password,
    "role": role,
    "branch_name": branchName,
    "branch_address": branchAddress,
  };
}
