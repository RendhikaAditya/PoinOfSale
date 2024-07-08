// To parse this JSON data, do
//
//     final modelDetailHistory = modelDetailHistoryFromJson(jsonString);

import 'dart:convert';

ModelDetailHistory modelDetailHistoryFromJson(String str) => ModelDetailHistory.fromJson(json.decode(str));

String modelDetailHistoryToJson(ModelDetailHistory data) => json.encode(data.toJson());

class ModelDetailHistory {
  bool? isSuccess;
  String? message;
  List<Datum>? data;

  ModelDetailHistory({
    this.isSuccess,
    this.message,
    this.data,
  });

  factory ModelDetailHistory.fromJson(Map<String, dynamic> json) => ModelDetailHistory(
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
  String? detailId;
  String? transactionId;
  String? productId;
  String? quantity;
  String? price;
  String? employeeId;
  String? branchId;
  String? paymentMethod;
  String? total;
  DateTime? date;
  String? categoryId;
  String? productName;
  String? stock;

  Datum({
    this.detailId,
    this.transactionId,
    this.productId,
    this.quantity,
    this.price,
    this.employeeId,
    this.branchId,
    this.paymentMethod,
    this.total,
    this.date,
    this.categoryId,
    this.productName,
    this.stock,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    detailId: json["detail_id"],
    transactionId: json["transaction_id"],
    productId: json["product_id"],
    quantity: json["quantity"],
    price: json["price"],
    employeeId: json["employee_id"],
    branchId: json["branch_id"],
    paymentMethod: json["payment_method"],
    total: json["total"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    categoryId: json["category_id"],
    productName: json["product_name"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "detail_id": detailId,
    "transaction_id": transactionId,
    "product_id": productId,
    "quantity": quantity,
    "price": price,
    "employee_id": employeeId,
    "branch_id": branchId,
    "payment_method": paymentMethod,
    "total": total,
    "date": date?.toIso8601String(),
    "category_id": categoryId,
    "product_name": productName,
    "stock": stock,
  };
}
