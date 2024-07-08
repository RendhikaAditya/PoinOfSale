import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/model/modelCategory.dart';
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/view/manageStore/branch/branchListPage.dart';
import 'package:poinofsale/view/manageStore/category/categoryListPage.dart';
import 'package:poinofsale/widget/custom_text_field.dart';
import 'package:poinofsale/widget/password_text_field.dart';
import 'package:http/http.dart' as http;

import '../../../model/modelCategory.dart';

class AddCategory extends StatefulWidget {
  final Datum? item;
  AddCategory({Key? key, required this.item}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtDesc = TextEditingController();
  bool? isLoading;

  Future<ModelBase?> addCategory() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response? res;

      if (widget.item == null) {
        // Membuat data karyawan baru
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}category.php'),
          body: {
            "action": "create",
            "name_category": _txtName.text.toString(),
            "description_category": _txtDesc.text.toString(),
          },
        );
      } else {
        // Memperbarui data karyawan yang sudah ada
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}category.php'),
          body: {
            "action": "update",
            "id": widget.item!.id,
            "name_category": _txtName.text.toString(),
            "description_category": _txtDesc.text.toString(),
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
            MaterialPageRoute(builder: (context) => CategoryListPage()),
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

  Future<ModelBase?> deleteCategory() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}category.php'),
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
            MaterialPageRoute(builder: (context) => CategoryListPage()),
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
      _txtName.text = widget.item!.nameCategory!;
      _txtDesc.text = widget.item!.descriptionCategory!;
    } else {
      _txtName.clear();
      _txtDesc.clear();

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
              'Category',
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
            Text("Category Name"),
            CustomTextField(hintText: "Category Name", controller: _txtName),
            SizedBox(height: 20),
            Text("Category Address"),
            CustomTextField(hintText: "Address", controller: _txtDesc),
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
                    deleteCategory();
                  },
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: isLoading == true
                      ? CircularProgressIndicator()
                      : Text(
                    'Delete Category',
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
                  addCategory();
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                label: isLoading == true
                    ? CircularProgressIndicator()
                    : Text(
                  widget.item == null ? 'Add New Category' : 'Update Category',
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
