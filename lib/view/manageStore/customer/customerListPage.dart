import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/view/manageStore/customer/addCustomer.dart';
import 'package:poinofsale/view/manageStore/manageStorePage.dart';
import 'package:poinofsale/widget/widget_menu.dart';

import '../../../model/modelCustomer.dart';



class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late Future<List<Datum>?> _futureCustomer;
  Future<List<Datum>?> getCustomer() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}customers.php'));

      var productResponse = modelCustomerFromJson(res.body);

      if (productResponse.isSuccess == true) {
        print("Data diperoleh :: ${productResponse.data?.length}");
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

  @override
  void initState() {
    super.initState();
    _fetchCustomerData();

  }

  void _fetchCustomerData() async {
    setState(() {
      _futureCustomer = getCustomer();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchCustomerData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(padding: EdgeInsets.only(right: 50),child: Text('Customer', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),),),
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
      body: Container(
        child: Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _futureCustomer,
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
                          return Column(
                            children: [
                              WidgeteMenu(title: "Nama\t\t\t\t\t\t\t\t${item.customersName}\nEmail\t\t\t\t\t\t\t\t${item.customersEmail}\nNo Hp\t\t\t\t\t\t\t${item.phoneNumber}\nAlamat\t\t\t\t\t\t${item.customersAddress}", navigatorPush: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddCustomer(item: item,)),
                                );
                              }),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    );
                  }
                }
              },
            )
        ),
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
                      AddCustomer(item: null,)),
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
          ),
          label: Text('Add New Customer', style: TextStyle(color: Colors.white), textAlign: TextAlign.start,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
