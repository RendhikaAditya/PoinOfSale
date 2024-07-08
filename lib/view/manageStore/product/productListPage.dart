import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/view/manageStore/manageStorePage.dart';
import 'package:poinofsale/widget/widget_menu.dart';
import 'package:poinofsale/widget/widget_product.dart';

import '../../../model/crudProductModel.dart';
import 'addProduct.dart';
import 'package:poinofsale/model/modelBranch.dart' as branch;



class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<Datum>?> _futureProduct;
  Future<List<Datum>?> getProduct(String id) async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}ProductCrud.php?id=$id'));

      var productResponse = modelCrudProductFromJson(res.body);

      if (productResponse.isSuccess == true) {
        print("Data diperoleh :: ${productResponse.data?.length} \n$id");
        List<Datum>? result = productResponse.data;
        if (result != null) {
          // Filter the result based on user ID
          // List<Datum> filteredResult = result.where((datum) => datum.idUser == sessionManager.idUser).toList();

          setState(() {
            // totalItem = productResponse!.totalQty!;
            // totalPrice = productResponse!.totalPrice!;
          });

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


  String? dropdownValue;
  List<branch.Datum> options = [];
  late Future<List<branch.Datum>?> _futureBranch;
  String? selectedBrachId;
  Future<List<branch.Datum>?> getBranch() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}getBranch.php'));

      var productResponse = branch.modelBranchFromJson(res.body);

      if (productResponse.isSuccess == true) {
        print("Data diperoleh :: ${productResponse.data?.length}");
        List<branch.Datum>? result = productResponse.data;
        if (result != null) {
          setState(() {
            options = result;
            dropdownValue = options.first.branchName;
            selectedBrachId = options.first.id;
            _fetchProductData(selectedBrachId!);
          });
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

  @override
  void initState() {
    super.initState();
    _futureBranch = getBranch();
  }
  void _fetchProductData(String id) async {
    setState(() {
      _futureProduct = getProduct("$selectedBrachId");
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProductData("$selectedBrachId");
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
        title: Center(child: Padding(padding: EdgeInsets.only(right: 50),child: Text('Product', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),),),
        leading: IconButton(
          icon: Center(child: Icon(Icons.arrow_back, color: Colors.blue),),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => ManageStorePage()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Branch"),
                FutureBuilder<List<branch.Datum>?>(
                  future: _futureBranch,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No Data Available');
                    } else {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.chevron_right_rounded),
                            isExpanded: true,
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            onChanged: (String? newValue) {

                              branch.Datum? selectedDatum = options.firstWhere(
                                    (datum) => datum.branchName == newValue,
                              );
                              print('Selected ID: ${selectedDatum.id}');
                              selectedBrachId = selectedDatum.id;
                              setState(() {
                                dropdownValue = newValue;
                                selectedBrachId = selectedDatum.id;
                                _fetchProductData("$selectedBrachId");
                              });
                            },
                            items: options.map<DropdownMenuItem<String>>((branch.Datum value) {
                              return DropdownMenuItem<String>(
                                value: value.branchName,
                                child: Text(value.branchName ?? ''),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Expanded(
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
                        if(data.length==0){
                          return const Center(
                            child: Text("Belum ada data pada branch ini."),
                          );
                        }else{
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
                                return Column(
                                  children: [
                                    WidgetProduct(
                                        title: item.name.toString(),
                                        subtitle1: formatRupiah(item.price.toString()),
                                        subtitle2: "Stok : ${item.stock} Pcs",
                                        imageUrl: "${ApiUrl().baseUrl}image/${item.image}",
                                        navigatorPush: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddProduct(item: item,)),
                                          );
                                        }
                                    ),
                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          );
                        }
                      }
                    }
                  },
                )
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        width: double.maxFinite,
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AddProduct(item: null,)),
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
          ),
          label: Text('Add New Product', style: TextStyle(color: Colors.white), textAlign: TextAlign.start,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
