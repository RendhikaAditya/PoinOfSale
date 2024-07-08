import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/modelDetaiHistory.dart';
import '../../utils/apiUrl.dart';

class DetailHistoryPage extends StatefulWidget {
  final String idTransaction;
  DetailHistoryPage({Key? key, required this.idTransaction}): super(key: key);

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  late Future<List<Datum>?> _futureDetailHistory;
  String total = "";
  String payment = "";
  String formatRupiah(String angkaStr) {
    try {
      int angka = int.parse(angkaStr);
      String rupiahStr = "Rp " + angka.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
      return rupiahStr;
    } catch (e) {
      return "Input harus berupa string angka yang valid";
    }
  }
  Future<List<Datum>?> getDetailHistory() async {
    try {
      String url = '${ApiUrl().baseUrl}detailHistory.php?transaction_id=${widget.idTransaction}';


      http.Response res = await http.get(Uri.parse(url));
      var historyResponse = modelDetailHistoryFromJson(res.body);

      if (historyResponse.isSuccess == true) {
        print("Data diperoleh :: ${historyResponse.data!.first.paymentMethod}");
        List<Datum>? result = historyResponse.data;
        if (result != null) {
          setState(() {
            total = formatRupiah(result.first.total.toString());
            payment = result.first.paymentMethod.toString();
          });
          return result;
        } else {
          print("Data kosong");
          return [];
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Data Tidak Ada")),
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
    _futureDetailHistory = getDetailHistory();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Detail History',
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
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.only(right: 20),
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Text(payment, style: TextStyle(color: Colors.white),),
            ),
          ),
          SizedBox(height: 10,),
          Divider(),
          SizedBox(height: 10,),
          Expanded(
            child: FutureBuilder<List<Datum>?>(
              future: _futureDetailHistory,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Container(
                    margin: EdgeInsets.only(top: 100),
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                } else if (snapshot.hasData) {
                  List<Datum>? data = snapshot.data;
                  if (data != null && data.isNotEmpty) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        Datum history = data[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetailHistoryPage(idTransaction: history.transactionId.toString())),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                                      child: Text("${history.quantity}", style: TextStyle(color: Colors.white),),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("${history.productName}", style: TextStyle(fontSize: 20),),
                                    Spacer(),
                                    Text(formatRupiah(history.price.toString().split(".")[0]), style: TextStyle(fontSize: 18),)
                                  ],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Divider(),
                              SizedBox(height: 10,)
                            ],
                          ),
                        );
                      },
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
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 40, right: 20,bottom: 30),
        child: Row(
          children: [
            Text("Total", style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),),
            Spacer(),
            Text("${total}"),
          ],
        )
      ),

    );
  }
}
