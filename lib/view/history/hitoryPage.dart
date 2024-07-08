import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modelHistory.dart';
import 'package:poinofsale/view/history/detailHistory.dart';
import 'package:poinofsale/widget/custom_history_widget.dart';
import 'package:http/http.dart' as http;
import '../../utils/apiUrl.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<Datum>?> _futureHistory;
  DateTimeRange? _selectedDateRange;
  Future<List<Datum>?> getHistory() async {
    try {
      String url = '${ApiUrl().baseUrl}getHistory.php';
      if (_selectedDateRange != null) {
        String date1 = _selectedDateRange!.start.toString().split(' ')[0];
        String date2 = _selectedDateRange!.end.toString().split(' ')[0];
        url += '?date1=$date1&date2=$date2';
      }

      http.Response res = await http.get(Uri.parse(url));
      var historyResponse = modelHistoryFromJson(res.body);

      if (historyResponse.isSuccess == true) {
        print("Data diperoleh :: ${historyResponse.data!.first.paymentMethod}");
        List<Datum>? result = historyResponse.data;
        if (result != null) {
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
    _futureHistory = getHistory();
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
  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: _selectedDateRange,
    );

    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _futureHistory = getHistory(); // Refresh the data with the selected date range
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Histoy Transaction',
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
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: () => _selectDateRange(context),
              child: Row(
                children: [
                  Icon(Icons.date_range_outlined),
                  SizedBox(width: 10,),
                  _selectedDateRange != null
                    ?Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        "Selected range: ${_selectedDateRange!.start.toString().split(' ')[0]} - ${_selectedDateRange!.end.toString().split(' ')[0]}",
                      ),
                    )
                  : Text("Filter Date"),
                  Spacer(),
                  Icon(Icons.chevron_right_rounded)
                ],
              ),
            ),

            Divider(),
            Expanded(
              child: FutureBuilder<List<Datum>?>(
                future: _futureHistory,
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
                                        DetailHistoryPage(idTransaction: history.id.toString())),
                              );
                            },
                            child: Column(
                              children: [
                                CustomHistoryWidget(
                                  textHarga: "${history.paymentMethod} - ${formatRupiah(history.total.toString().split(".").first)}",
                                  textTanggal: "${history.date}",
                                ),
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
      ),
    );
  }
}
