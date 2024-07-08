import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/model/modelProduct.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/payment/paymentPage.dart';
import 'package:poinofsale/model/modelCategory.dart' as category;

import '../../model/totalModel.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key});

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  int qty = 0;
  int totalItem = 0;
  int totalPrice = 0;
  bool _isSearchExpanded = false;
  String _selectedCategory ="";
  TextEditingController _searchController = TextEditingController();


  late Future<List<Datum>?> _futureProduct;
  Future<List<Datum>?> getProduct(String category) async {
    category=="All Product"?category="":category=category;
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}product.php?employe_id=${sessionManager.id}&branch_id=${sessionManager.idBranch}&nameCategory=$category'));

      print("${ApiUrl().baseUrl}product.php?employe_id=${sessionManager.id}&branch_id=${sessionManager.idBranch}&nameCategory=$category')");
      var productResponse = modelProductFromJson(res.body);

      if (productResponse.isSuccess == true) {
        List<Datum>? result = productResponse.data;
        if (result != null) {

            // setState(() {
            //   totalItem = productResponse!.totalQty!;
            //   totalPrice = productResponse!.totalPrice!;
            // });
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

  String? dropdownValueCategory;
  List<category.Datum> optionsCategory = [];
  late Future<List<category.Datum>?> _futureCategory;
  String? selectedCategoryId;

  Future<List<category.Datum>?> getCategory() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}category.php'));

      var categoryResponse = category.modelCategoryFromJson(res.body);

      if (categoryResponse.isSuccess == true) {
        print("Data diperoleh :: ${categoryResponse.data?.length}");
        List<category.Datum>? result = categoryResponse.data;
        if (result != null) {
          // Add "All Product" option
          result.insert(0, category.Datum(id: "0", nameCategory: "All Product"));

          setState(() {
            optionsCategory = result;
            dropdownValueCategory = optionsCategory.first.nameCategory;
            _selectedCategory = optionsCategory.first.nameCategory.toString();
            getProduct(_selectedCategory);
          });
          return result;
        } else {
          print("Data kosong");
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${categoryResponse.message}")),
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
    if(sessionManager.role=="Employee"){
      setState(() {
        getTotal();
      });
    }

    _futureProduct = getProduct("$_selectedCategory");
      // sessionManager.getSession();
      _futureCategory = getCategory();

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
          _futureProduct = getProduct("$_selectedCategory");
          getTotal();
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
      backgroundColor: Colors.white70,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 1, thickness: 1),
          Container(
            height: 50,
            width: double.maxFinite,
            color: Colors.white,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Expanded(
                    child:FutureBuilder<List<category.Datum>?>(
                      future: _futureCategory,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Text('No Data Available');
                        } else {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: dropdownValueCategory,
                                icon: Icon(Icons.search),
                                isExpanded: true,
                                iconSize: 24,
                                iconDisabledColor: Colors.white,
                                iconEnabledColor: Colors.white,
                                elevation: 16,
                                style: TextStyle(color: Colors.black, fontSize: 16),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValueCategory = newValue;
                                  });
                                  category.Datum? selectedDatum = optionsCategory.firstWhere(
                                        (datum) => datum.nameCategory == newValue,
                                  );
                                  print('Selected ID: ${selectedDatum.id}');
                                  selectedCategoryId = selectedDatum.id;
                                  _futureProduct = getProduct("${selectedDatum.nameCategory}");

                                },
                                items: optionsCategory.map<DropdownMenuItem<String>>((category.Datum value) {
                                  return DropdownMenuItem<String>(
                                    value: value.nameCategory,
                                    child: Text(
                                      "${value.nameCategory} ➤" ?? '',
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                ),
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      VerticalDivider(
                        indent: 0,
                        endIndent: 0,
                        width: 0,
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        width: _isSearchExpanded ? 280.0 : 48.0,
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                              hintText: 'Search',
                              prefixIcon: _isSearchExpanded?Icon(Icons.clear):Icon(CupertinoIcons.search),
                              border: InputBorder.none,
                            ),
                            onTap: () {
                              setState(() {
                                _isSearchExpanded = !_isSearchExpanded;
                                _searchController.clear();
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                _isSearchExpanded = !_isSearchExpanded;
                                _searchController.clear();
                              });
                            },
                          ),
                        )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Divider(height: 1, thickness: 1),
          Expanded(
              child: FutureBuilder<List<Datum>?>(
                future: _futureProduct,
                builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    final data = snapshot.data;
                    if (data == null) {
                      return const Center(
                        child: Text("No data found."),
                      );
                    } else {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        height: double.infinity,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: data.length,
                          padding: EdgeInsets.only(bottom: 80.0),
                          itemBuilder: (context, index) {
                            Datum item = data[index];
                            qty = item.qty!.toInt();
                            print(data.length);
                            return GestureDetector(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailProductPage(product: item)));
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [

                                      ],
                                    ),
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage("${ApiUrl().baseUrl}image/${item.image.toString()}"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 20,),
                                            Text(
                                              item.name.toString(),
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4.0),
                                            Text(
                                              formatRupiah(item.price.toString()),
                                              textAlign: TextAlign.start,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: sessionManager.role=="Employee"?true:false,
                                      child: Container(
                                        margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                                        child: item.qty==0
                                            ? GestureDetector(
                                                onTap: (){
                                                  addCart(item.id.toString(), "1", item.price.toString());
                                                },
                                                child: Icon(Icons.add_box_rounded, color: Colors.blue, size: 40,),
                                              )
                                            : Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        // qty = item.qty!.toInt();
                                                        qty = qty > 0 ? qty - 1 : 0;
                                                        addCart(item.id.toString(), "-1", item.price.toString());
                                                        // item.qty = qty.toString();
                                                        // updateTotalPrice(cart);
                                                      });
                                                    },
                                                    child: Icon(CupertinoIcons.minus_circled, color: Colors.red),
                                                  ),
                                                  Text("  $qty  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        // qty = item.qty!.toInt();
                                                        qty = qty + 1;
                                                        addCart(item.id.toString(), "1", item.price.toString());
                                                        // data.quantity = qty.toString();
                                                        // updateTotalPrice(cart);
                                                      });
                                                    },
                                                    child: Icon(CupertinoIcons.plus_circle, color: Colors.green),
                                                  ),
                                                ],
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              )
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
