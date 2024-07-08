import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/view/manageStore/category/categoryListPage.dart';
import 'package:poinofsale/widget/custom_text_field.dart';
import 'package:http/http.dart' as http;

import '../../../model/modelCustomer.dart';
import 'customerListPage.dart';


class AddCustomer extends StatefulWidget {
  final Datum? item;
  AddCustomer({Key? key, required this.item}) : super(key: key);

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtNohp = TextEditingController();
  TextEditingController _txtEmail = TextEditingController();
  TextEditingController _txtAddress = TextEditingController();

  bool? isLoading;

  Future<ModelBase?> addCustomer() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response? res;

      if (widget.item == null) {
        // Membuat data karyawan baru
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}customers.php'),
          body: {
            "action": "create",
            "customers_name": _txtName.text.toString(),
            "phone_number": _txtNohp.text.toString(),
            "customers_email": _txtEmail.text.toString(),
            "customers_address": _txtAddress.text.toString(),

          },
        );
      } else {
        // Memperbarui data karyawan yang sudah ada
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}customers.php'),
          body: {
            "action": "update",
            "id": widget.item!.id,
            "customers_name": _txtName.text.toString(),
            "phone_number": _txtNohp.text.toString(),
            "customers_email": _txtEmail.text.toString(),
            "customers_address": _txtAddress.text.toString(),
          },
        );
      }

      ModelBase data = modelBaseFromJson(res.body);
      // print("$selectedId\n${_txtUsername.text}\n${_txtPassword}");

      if (data.isSuccess == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CustomerListPage()),
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

  Future<ModelBase?> deleteCustomer() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}customers.php'),
        body: {
          "action": "delete",
          "id": widget.item!.id!,
        },
      );

      ModelBase data = modelBaseFromJson(res.body);
      // print("$selectedId\n${_txtUsername.text}\n${_txtPassword}");

      if (data.isSuccess == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CustomerListPage()),
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



  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _txtName.text = widget.item!.customersName!;
      _txtNohp.text = widget.item!.phoneNumber!;
      _txtAddress.text = widget.item!.customersAddress!;
      _txtEmail.text = widget.item!.customersEmail!;
    } else {
      _txtName.clear();
      _txtNohp.clear();
      _txtAddress.clear();
      _txtEmail.clear();
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
              'Customer',
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
            Text("Customers Name"),
            CustomTextField(hintText: "Name", controller: _txtName),
            SizedBox(height: 20),
            Text("Customers Phone Numbers"),
            CustomTextField(hintText: "Phone Number", controller: _txtNohp),
            SizedBox(height: 20),
            Text("Customers Email"),
            CustomTextField(hintText: "Email", controller: _txtEmail),
            SizedBox(height: 20),
            Text("Customers Address"),
            CustomTextField(hintText: "Address", controller: _txtAddress),
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
                    deleteCustomer();
                  },
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: isLoading == true
                      ? CircularProgressIndicator()
                      : Text(
                    'Delete Customer',
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
                  addCustomer();
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                label: isLoading == true
                    ? CircularProgressIndicator()
                    : Text(
                  widget.item == null ? 'Add New Customer' : 'Update Customer',
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
