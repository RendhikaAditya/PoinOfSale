import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modelReport.dart';
import 'package:poinofsale/widget/item_report_widget.dart';
import 'package:http/http.dart' as http;

import '../../utils/apiUrl.dart';
import '../../widget/item_report_payment_widget.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<List<Product>?> _futureProduct;
  late Future<List<PaymentMethod>?> _futurePayment;

  Future<List<Product>?> getProduct() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}report.php'));
      var productResponse = modelReportFromJson(res.body);

      if (productResponse.stats == true) {
        print("Data diperoleh :: ${productResponse.products!.first.productName}");
        List<Product>? result = productResponse.products;
        if (result != null) {
          return result;
        } else {
          print("Data kosong");
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengambil data")),
        );
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
      return null;
    }
  }

  Future<List<PaymentMethod>?> getPayment() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}report.php'));
      var paymentResponse = modelReportFromJson(res.body);

      if (paymentResponse.stats == true) {
        print("Data diperoleh :: ${paymentResponse.products!.first.productName}");
        List<PaymentMethod>? result = paymentResponse.paymentMethods;
        if (result != null) {
          return result;
        } else {
          print("Data kosong");
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal mengambil data")),
        );
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProduct = getProduct();
    _futurePayment = getPayment();
  }

  String formatRupiah(String angkaStr) {
    try {
      int angka = int.parse(angkaStr);
      String rupiahStr = "Rp " + angka.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
      return rupiahStr;
    } catch (e) {
      return "Input harus berupa string angka yang valid";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Report',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        leading: IconButton(
          icon: Center(
            child: Icon(Icons.arrow_back, color: Colors.blue),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                    child: Text(
                      "Best-Selling Product",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  FutureBuilder<List<Product>?>(
                    future: _futureProduct,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(child: Text('Error: ${snapshot.error}')),
                        );
                      } else if (snapshot.hasData) {
                        List<Product>? products = snapshot.data;
                        if (products != null && products.isNotEmpty) {
                          print(":::${products.first.productName}");

                          return SizedBox(
                            height: 430, // Atur tinggi yang sesuai
                            child: ListView.builder(
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                Product product = products[index];
                                return ItemReportWidget(
                                  mainText1: "${product.productName}",
                                  subText1: "${product.salesPercentage}%",
                                  mainText2: "${formatRupiah(product.totalSales.toString().split(".").first)}",
                                  subText2: "${product.totalQuantity} Sales",
                                  progressValue: double.parse(product.salesPercentage.toString()),
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Center(child: Text('No favorite products found.')),
                          );
                        }
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(child: Text('No data available.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 10, top: 10, bottom: 5),
                    child: Text(
                      "Payment Method",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  FutureBuilder<List<PaymentMethod>?>(
                    future: _futurePayment,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(child: Text('Error: ${snapshot.error}')),
                        );
                      } else if (snapshot.hasData) {
                        List<PaymentMethod>? payments = snapshot.data;
                        if (payments != null && payments.isNotEmpty) {

                          return SizedBox(
                            height: 300, // Atur tinggi yang sesuai
                            child: ListView.builder(
                              itemCount: payments.length,
                              itemBuilder: (context, index) {
                                PaymentMethod payment = payments[index];
                                return ItemReportPaymentWidget(
                                  payment: "${payment.paymentMethod} - ${formatRupiah(payment.totalSales.toString().split(".").first)}",
                                  sales: "${payment.totalTransactions} Sales",
                                  presentase: "${payment.transactionsPercentage.toString().substring(0,4)}%",
                                );
                              },
                            ),
                          );
                        } else {
                          return Container(
                            margin: EdgeInsets.only(top: 100),
                            child: Center(child: Text('No favorite products found.')),
                          );
                        }
                      } else {
                        return Container(
                          margin: EdgeInsets.only(top: 100),
                          child: Center(child: Text('No data available.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      )
    );
  }
}
