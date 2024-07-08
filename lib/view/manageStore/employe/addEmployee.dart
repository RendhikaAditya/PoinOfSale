import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/model/modelBranch.dart' as branch;
import 'package:poinofsale/model/modelEmployee.dart' as employee;
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/view/manageStore/employe/employeeListPage.dart';
import 'package:poinofsale/widget/custom_text_field.dart';
import 'package:poinofsale/widget/password_text_field.dart';
import 'package:http/http.dart' as http;

class AddEmployee extends StatefulWidget {
  final employee.Datum? item;
  AddEmployee({Key? key, required this.item}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController _txtUsername = TextEditingController();
  TextEditingController _txtPassword = TextEditingController();
  String? dropdownValue;
  List<branch.Datum> options = [];
  late Future<List<branch.Datum>?> _futureBranch;
  String? selectedId;
  bool? isLoading;

  Future<ModelBase?> addEmployee() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response? res;

      if (widget.item == null) {
        // Membuat data karyawan baru
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}employee.php'),
          body: {
            "action": "create",
            "branch_id": selectedId,
            "username": _txtUsername.text,
            "password": _txtPassword.text,
          },
        );
      } else {
        // Memperbarui data karyawan yang sudah ada
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}employee.php'),
          body: {
            "action": "update",
            "id": widget.item!.id,
            "branch_id": selectedId,
            "username": _txtUsername.text,
            "password": _txtPassword.text,
          },
        );
      }

      ModelBase data = modelBaseFromJson(res.body);
      print("$selectedId\n${_txtUsername.text}\n${_txtPassword}");

      if (data.isSuccess == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EmployeListPage()),
                (route) => false,
          );
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          isLoading = false;
        });
      }

      return data;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }

    return null;
  }

  Future<ModelBase?> deleteEmployee() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}employee.php'),
        body: {
          "action": "delete",
          "id": widget.item!.id!,
        },
      );

      ModelBase data = modelBaseFromJson(res.body);
      print("$selectedId\n${_txtUsername.text}\n${_txtPassword}");

      if (data.isSuccess == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => EmployeListPage()),
                (route) => false,
          );
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          isLoading = false;
        });
      }

      return data;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }

    return null;
  }


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
            if (options.isNotEmpty && widget.item == null) {
              dropdownValue = options.first.branchName;
            }
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
    if (widget.item != null) {
      _txtUsername.text = widget.item!.username!;
      selectedId = widget.item!.branchId!;
    } else {
      _txtUsername.clear(); // Kosongkan controller jika item null
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
              'Employee',
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
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (widget.item != null && dropdownValue == null) {
                    // Set dropdownValue jika item tidak null dan dropdownValue belum diatur
                    branch.Datum? selectedDatum = options.firstWhere(
                          (datum) => datum.id == widget.item!.branchId,
                      orElse: () => options.first,
                    );
                    dropdownValue = selectedDatum.branchName;
                  }
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
                        icon: Icon(Icons.arrow_downward),
                        isExpanded: true,
                        iconSize: 24,
                        elevation: 16,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue;
                          });
                          branch.Datum? selectedDatum = options.firstWhere(
                                (datum) => datum.branchName == newValue,
                          );
                          print('Selected ID: ${selectedDatum.id}');
                          selectedId = selectedDatum.id;
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
            SizedBox(height: 20),
            Text("Username"),
            CustomTextField(hintText: "Username", controller: _txtUsername),
            SizedBox(height: 20),
            Text("Password"),
            PasswordTextField(hintText: "Password", controller: _txtPassword)
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: widget.item!=null,
              child: Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: FloatingActionButton.extended(
                  onPressed: () {
                    deleteEmployee();
                  },
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: isLoading == true
                      ? CircularProgressIndicator()
                      : Text(
                    'Delete Employee',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.maxFinite,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: FloatingActionButton.extended(
                onPressed: () {
                  addEmployee();
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                label: isLoading == true
                    ? CircularProgressIndicator()
                    : Text(
                  widget.item == null ? 'Add New Employee' : 'Update Employee',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
