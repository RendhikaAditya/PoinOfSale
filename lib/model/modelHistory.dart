// To parse this JSON data, do
//
//     final modelHistory = modelHistoryFromJson(jsonString);

import 'dart:convert';

ModelHistory modelHistoryFromJson(String str) => ModelHistory.fromJson(json.decode(str));

String modelHistoryToJson(ModelHistory data) => json.encode(data.toJson());

class ModelHistory {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelHistory({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelHistory.fromJson(Map<String, dynamic> json) => ModelHistory(
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
  String? employeeId;
  String? branchId;
  String? paymentMethod;
  String? total;
  DateTime? date;

  Datum({
    this.id,
    this.employeeId,
    this.branchId,
    this.paymentMethod,
    this.total,
    this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    employeeId: json["employee_id"],
    branchId: json["branch_id"],
    paymentMethod: json["payment_method"],
    total: json["total"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "employee_id": employeeId,
    "branch_id": branchId,
    "payment_method": paymentMethod,
    "total": total,
    "date": date?.toIso8601String(),
  };
}
