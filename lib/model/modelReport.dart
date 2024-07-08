// To parse this JSON data, do
//
//     final modelReport = modelReportFromJson(jsonString);

import 'dart:convert';

ModelReport modelReportFromJson(String str) => ModelReport.fromJson(json.decode(str));

String modelReportToJson(ModelReport data) => json.encode(data.toJson());

class ModelReport {
  bool? stats;
  List<Product>? products;
  List<PaymentMethod>? paymentMethods;

  ModelReport({
    this.stats,
    this.products,
    this.paymentMethods,
  });

  factory ModelReport.fromJson(Map<String, dynamic> json) => ModelReport(
    stats: json["stats"],
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    paymentMethods: json["payment_methods"] == null ? [] : List<PaymentMethod>.from(json["payment_methods"]!.map((x) => PaymentMethod.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "stats": stats,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "payment_methods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
  };
}

class PaymentMethod {
  String? paymentMethod;
  String? totalTransactions;
  String? transactionsPercentage;
  String? totalSales;

  PaymentMethod({
    this.paymentMethod,
    this.totalTransactions,
    this.transactionsPercentage,
    this.totalSales,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    paymentMethod: json["payment_method"],
    totalTransactions: json["total_transactions"],
    transactionsPercentage: json["transactions_percentage"],
    totalSales: json["total_sales"],
  );

  Map<String, dynamic> toJson() => {
    "payment_method": paymentMethod,
    "total_transactions": totalTransactions,
    "transactions_percentage": transactionsPercentage,
    "total_sales": totalSales,
  };
}

class Product {
  String? productName;
  String? totalSales;
  String? totalQuantity;
  String? salesPercentage;

  Product({
    this.productName,
    this.totalSales,
    this.totalQuantity,
    this.salesPercentage,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productName: json["product_name"],
    totalSales: json["total_sales"],
    totalQuantity: json["total_quantity"],
    salesPercentage: json["sales_percentage"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "total_sales": totalSales,
    "total_quantity": totalQuantity,
    "sales_percentage": salesPercentage,
  };
}
