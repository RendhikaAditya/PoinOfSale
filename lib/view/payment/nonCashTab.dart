import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/payment/nonCashTab.dart';
import 'package:poinofsale/view/payment/successPaymentpage.dart';
import 'package:http/http.dart' as http;

class NonCashTab extends StatefulWidget {
  final String totalPrice;
  NonCashTab({Key? key, required this.totalPrice}) : super(key: key);

  @override
  State<NonCashTab> createState() => _NonCashTabState();
}

class _NonCashTabState extends State<NonCashTab> {
  String selectedPayment = '';

  void selectPayment(String image) {
    setState(() {
      selectedPayment = image;
    });
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
      print(data);


      if (data.isSuccess==true) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    SuccessPage(paymentMethod: paymenMethod, totalPrice: "0",)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 100, left: 16, right: 16),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "E-Wallet",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => selectPayment('Dana'),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'Dana'
                              ? Colors.blue[100]
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          "images/ic_dana.png",
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => selectPayment('Shopee Pay'),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'Shopee Pay'
                              ? Colors.blue[100]
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          "images/ic_sPay.png",
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => selectPayment('Gopay'),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'Gopay'
                              ? Colors.blue[100]
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          "images/ic_goPay.png",
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 16, right: 16),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bank",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => selectPayment('BRI'),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'BRI'
                              ? Colors.blue[100]
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          "images/ic_bri.png",
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => selectPayment('BNI'),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'BNI'
                              ? Colors.blue[100]
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          "images/ic_bni.png",
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () => selectPayment('BCA'),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'BCA'
                              ? Colors.blue[100]
                              : Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset(
                          "images/ic_bca.png",
                          width: 80,
                          height: 40,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            addTransaction("${sessionManager.id}", "${sessionManager.idBranch}", selectedPayment);
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
