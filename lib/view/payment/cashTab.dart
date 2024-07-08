

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/payment/successPaymentpage.dart';
import 'package:poinofsale/widget/rupiahInputWidget.dart';
import 'package:http/http.dart' as http;

class CashTab extends StatefulWidget {

  final String totalPrice;
  CashTab({Key? key, required this.totalPrice}) : super(key: key);

  @override
  State<CashTab> createState() => _CashTabState();
}

class _CashTabState extends State<CashTab> {
  TextEditingController _controller = TextEditingController();
  int totalPrice = 0;

  int parseRupiah(String rupiahStr) {
    // Hapus "Rp " dan "." dari string
    String cleanedStr = rupiahStr.replaceAll(RegExp(r'[^0-9]'), '');

    // Ubah string menjadi integer
    int parsedValue = int.parse(cleanedStr);

    return parsedValue;
  }


  Future<ModelBase?> addTransaction(String? idEmploye, String idBranch , String paymenMethod) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}addTransaction.php'),
        body: {
          "employee_id": "$idEmploye",
          "branch_id": "$idBranch",
          "payment_method": paymenMethod,
        },
      );

      ModelBase data = modelBaseFromJson(res.body);

      num change = parseRupiah(_controller.text.toString())-int.parse(widget.totalPrice);

      if (data.isSuccess==true) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SuccessPage(paymentMethod: paymenMethod,totalPrice:"${formatRupiah(change.toString())}",))
          );
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
  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      int inputValue = int.parse(value.replaceAll(RegExp('[^0-9]'), ''));
      setState(() {
        totalPrice += inputValue;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Menambahkan ini untuk mengatur posisi ke tengah
              children: [
                Icon(Icons.account_balance_wallet_outlined, color: Colors.black,),
                SizedBox(width: 8), // Menambahkan sedikit ruang antara ikon dan teks
                Text("Exact Amount", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),)
              ],
            ),
            SizedBox(height: 20,),
            RupiahInputWidget(controller: _controller,onSubmitted: _handleSubmitted,),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            addTransaction("${sessionManager.id}", "${sessionManager.idBranch}", "Cash");
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
          ),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ENTER', style: TextStyle(color: Colors.white,fontSize: 20)),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
