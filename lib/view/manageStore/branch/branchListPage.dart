import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/view/manageStore/branch/addBranch.dart';
import 'package:poinofsale/view/manageStore/employe/addEmployee.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/view/manageStore/manageStorePage.dart';
import 'package:poinofsale/widget/widget_menu.dart';

import '../../../model/modelBranch.dart';

class BranchListPage extends StatefulWidget {
  const BranchListPage({super.key});

  @override
  State<BranchListPage> createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  late Future<List<Datum>?> _futureBranche;
  Future<List<Datum>?> getBranche() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}branch.php'));

      var productResponse = modelBranchFromJson(res.body);

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
    _fetchBranchData();

  }

  void _fetchBranchData() async {
    setState(() {
      _futureBranche = getBranche();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchBranchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(padding: EdgeInsets.only(right: 50),child: Text('Branch', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),),),
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
              future: _futureBranche,
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
                              WidgeteMenu(title: "${item.branchName}\n${item.branchAddress}", navigatorPush: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddBranch(item: item,)),
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
                      AddBranch(item: null,)),
            );
          },
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
          ),
          label: Text('Add New Branch', style: TextStyle(color: Colors.white), textAlign: TextAlign.start,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
