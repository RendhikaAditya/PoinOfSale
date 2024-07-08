import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/model/totalModel.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/payment/cashTab.dart';
import 'package:poinofsale/view/payment/nonCashTab.dart';
import 'package:poinofsale/view/payment/paymentPage.dart';
import 'package:poinofsale/widget/rupiahInputWidget.dart';


class PaymentPage extends StatefulWidget {
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int totalPrice = 10000000;


  @override
  void initState() {
    super.initState();
    getTotal();
    // sessionManager.getSession();
  }

  Future<ModelTotal?> getTotal() async {
    try {
      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}getTotal.php?employe_id=${sessionManager.id}'),
      );

      ModelTotal data = modelTotalFromJson(res.body);
      print(data);

      if (data.isSuccess==true) {
        setState(() {
          totalPrice = data.totalPrice!.toInt();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );
      }

      return data;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }

    return null;
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text('Paymen Method', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Cash'),
              Tab(text: 'Non-Cash'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CashTab(totalPrice: totalPrice.toString(),),
            NonCashTab(totalPrice: totalPrice.toString(),),
          ],
        ),
        floatingActionButton: Container(
          width: double.maxFinite,
          padding: EdgeInsets.only(top: 100),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: FloatingActionButton.extended(
            onPressed: () {

            },
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Sudut melengkung
            ),
            label: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Bill : '+'                                                           ', style: TextStyle(color: Colors.black87), textAlign: TextAlign.start,),
                Text('${formatRupiah(totalPrice.toString())}', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      ),

    );
  }
}



