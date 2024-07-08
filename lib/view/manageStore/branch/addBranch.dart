import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modeBase.dart';
import 'package:poinofsale/model/modelBranch.dart' as branch;
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/view/manageStore/branch/branchListPage.dart';
import 'package:poinofsale/widget/custom_text_field.dart';
import 'package:poinofsale/widget/password_text_field.dart';
import 'package:http/http.dart' as http;

class AddBranch extends StatefulWidget {
  final branch.Datum? item;
  AddBranch({Key? key, required this.item}) : super(key: key);

  @override
  State<AddBranch> createState() => _AddBranchState();
}

class _AddBranchState extends State<AddBranch> {
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtAddress = TextEditingController();
  bool? isLoading;

  Future<ModelBase?> addBranch() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response? res;

      if (widget.item == null) {
        // Membuat data karyawan baru
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}branch.php'),
          body: {
            "action": "create",
            "branch_name": _txtName.text.toString(),
            "branch_address": _txtAddress.text.toString(),
          },
        );
      } else {
        // Memperbarui data karyawan yang sudah ada
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}branch.php'),
          body: {
            "action": "update",
            "id": widget.item!.id,
            "branch_name": _txtName.text.toString(),
            "branch_address": _txtAddress.text.toString(),
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
            MaterialPageRoute(builder: (context) => BranchListPage()),
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

  Future<ModelBase?> deleteBranch() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}branch.php'),
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
            MaterialPageRoute(builder: (context) => BranchListPage()),
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
      _txtName.text = widget.item!.branchName!;
      _txtAddress.text = widget.item!.branchAddress!;
    } else {
      _txtName.clear();
      _txtAddress.clear();

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
              'Branch',
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
            Text("Branch Name"),
            CustomTextField(hintText: "Branch Name", controller: _txtName),
            SizedBox(height: 20),
            Text("Branch Address"),
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
                    deleteBranch();
                  },
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: isLoading == true
                      ? CircularProgressIndicator()
                      : Text(
                    'Delete Branch',
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
                  addBranch();
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                label: isLoading == true
                    ? CircularProgressIndicator()
                    : Text(
                  widget.item == null ? 'Add New Branch' : 'Update Branch',
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
