// To parse this JSON data, do
//
//     final modelBranch = modelBranchFromJson(jsonString);

import 'dart:convert';

ModelBranch modelBranchFromJson(String str) => ModelBranch.fromJson(json.decode(str));

String modelBranchToJson(ModelBranch data) => json.encode(data.toJson());

class ModelBranch {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelBranch({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelBranch.fromJson(Map<String, dynamic> json) => ModelBranch(
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
  String? branchName;
  String? branchAddress;

  Datum({
    this.id,
    this.branchName,
    this.branchAddress,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    branchName: json["branch_name"],
    branchAddress: json["branch_address"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_name": branchName,
    "branch_address": branchAddress,
  };
}
