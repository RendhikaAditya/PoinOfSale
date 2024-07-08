import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/favoriteModel.dart';
import 'package:poinofsale/model/totalModel.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/payment/paymentPage.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}


class _FavoritePageState extends State<FavoritePage> {
  late Future<List<Datum>?> _futureFavorite;
  int totalItem = 0;
  int totalPrice = 0;



  @override
  void initState() {
    super.initState();
    getTotal();
    _futureFavorite = getProductFav();
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

  Future<List<Datum>?> getProductFav() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}getFavorite.php?id=1'));
      var productResponse = modelProductFromJson(res.body);

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
                    Text("Special Menu"),
                  ],
                ),
              ],
            ),
          ),
          Divider(height: 1, thickness: 1),
          SizedBox(height: 10,),
          FutureBuilder<List<Datum>?>(
            future: _futureFavorite,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Container(margin: EdgeInsets.only(top: 100),child: Center(child: Text('Error: ${snapshot.error}')),);
              } else if (snapshot.hasData) {
                List<Datum>? products = snapshot.data;

                if (products != null && products.isNotEmpty) {


                  return Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 0.86,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        Datum product = products[index];
                        return Card(
                          elevation: 2.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage("${ApiUrl().baseUrl}image/${product.image.toString()}"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name ?? '',
                                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                                child: Text(
                                  '${formatRupiah(product.price.toString()) ?? ''}',
                                  style: TextStyle(fontSize: 14.0, color: Colors.grey[600]),
                                ),
                              ),
                            ],
                          ),
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
