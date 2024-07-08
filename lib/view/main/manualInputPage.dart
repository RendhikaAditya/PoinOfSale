import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/model/modelCartManual.dart';
import 'package:poinofsale/model/totalModel.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/payment/paymentPage.dart';
import 'package:poinofsale/widget/rupiahInputWidget.dart';
import 'package:http/http.dart' as http;

class ManualInputPage extends StatefulWidget {
  const ManualInputPage({super.key});

  @override
  State<ManualInputPage> createState() => _ManualInputPageState();
}

class _ManualInputPageState extends State<ManualInputPage> {
  late Future<List<Datum>?> _futureCart;

  TextEditingController _controller = TextEditingController();
  int totalItem = 0;
  int totalPrice = 0;

  Future<List<Datum>?> getCart() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}getManualInput.php?id=${sessionManager.id}'));
      var productResponse = modelCartManualFromJson(res.body);

      if (productResponse.isSuccess == true) {
        print("Data diperoleh :: ${productResponse.data?.length}");
        List<Datum>? result = productResponse.data;
        if (result != null) {
          // Filter the result based on user ID
          // List<Datum> filteredResult = result.where((datum) => datum.idUser == sessionManager.idUser).toList();

          return result;
        } else {
          print("Data kosong");
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${productResponse.message}")),
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


  Future<ModelBase?> addCart(String? idProduct, String q, String price) async {
    try {
      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}addToCart.php'),
        body: {
          "employe_id": "${sessionManager.id}",
          "product_id": idProduct,
          "qty": q,
          "price": price,
        },
      );

      ModelBase data = modelBaseFromJson(res.body);
      print(data);

      if (data.isSuccess==true) {
        setState(() {
          getTotal();
          _futureCart = getCart();

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




  void _handleSubmitted(String value) {
    if (value.isNotEmpty) {
      int inputValue = int.parse(value.replaceAll(RegExp('[^0-9]'), ''));
      setState(() {
        addCart("0", "1", inputValue.toString());
      });
      _controller.clear(); // Optional: Clear input field after summing up
    }
  }

  @override
  void initState() {
    super.initState();
    getTotal();
    _futureCart = getCart();
      // sessionManager.getSession();
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
          totalItem = data.totalQty!.toInt();
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
    return Scaffold(
      body: Column(
        children: [
          Divider(height: 1, thickness: 1),
          Container(
            height: 50,
            width: double.maxFinite,
            color: Colors.white,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Row(
                  children: [
                    SizedBox(width: 16),
                    Text("Manual Input"),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1),
          SizedBox(height: 10,),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: RupiahInputWidget(controller: _controller,onSubmitted: _handleSubmitted,),
            ),
          ),
          FutureBuilder<List<Datum>?>(
            future: _futureCart,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Container(margin: EdgeInsets.only(top: 100),child: Center(child: Text('Error: ${snapshot.error}')),);
              } else if (snapshot.hasData) {
                List<Datum>? products = snapshot.data;

                if (products != null && products.isNotEmpty) {


                  return Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Datum product = products[index];
                        return Card(
                          margin: EdgeInsets.all(10),
                          elevation: 2.0,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${formatRupiah(product.price.toString())} X ${product.qty}" ?? '',
                                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: (){
                                    addCart("0", "-${product.qty}", "${product.price}");
                                  },
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                      child: Icon(CupertinoIcons.delete, color: Colors.red,)
                                  ),
                                ),
                              ],
                            ),
                          )
                        );
                      },
                    ),
                  );
                } else {
                  return Container(margin: EdgeInsets.only(top: 100),child: Center(child: Text('No favorite products found.')),);
                }
              } else {
                return Container(margin: EdgeInsets.only(top: 100),child:Center(child: Text('No data available.')));
              }
            },
          )
        ],
      ),
      floatingActionButton: totalItem!=0?Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PaymentPage()),
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
          ),
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.white),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$totalItem Item'+'                                             ', style: TextStyle(color: Colors.white), textAlign: TextAlign.start,),
              Text('Total: ${formatRupiah(totalPrice.toString())}', style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ):null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
