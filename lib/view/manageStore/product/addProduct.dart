
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modelBranch.dart' as branch;
import 'package:poinofsale/model/crudProductModel.dart' as product;
import 'package:poinofsale/model/modelCategory.dart' as category;
import 'package:poinofsale/utils/apiUrl.dart';
import 'package:poinofsale/view/manageStore/product/productListPage.dart';
import 'package:poinofsale/widget/custom_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:poinofsale/widget/rupiahInputWidget.dart';
import 'package:image_picker/image_picker.dart';

import '../../../model/modeBase.dart';
import '../../../widget/image_picker.dart';
class AddProduct extends StatefulWidget {
  final product.Datum? item;
  AddProduct({Key? key, required this.item}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _txtName = TextEditingController();
  TextEditingController _txtDescription = TextEditingController();
  TextEditingController _txtPrice = TextEditingController();
  TextEditingController _txtStock = TextEditingController();

  String? dropdownValue;
  List<branch.Datum> options = [];
  late Future<List<branch.Datum>?> _futureBranch;
  String? selectedBrachId;

  String? dropdownValueCategory;
  List<category.Datum> optionsCategory = [];
  late Future<List<category.Datum>?> _futureCategory;
  String? selectedCategoryId;



  bool? isLoading;
  File? _image;
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _base64Image = base64Encode(_image!.readAsBytesSync());
        // print('Base64 Encoded Image: $_base64Image');
      } else {
        print('No image selected.');
      }
    });
  }
  Future<ModelBase?> addProduct() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response? res;

      if (widget.item == null) {
        res = await http.post(
          Uri.parse('${ApiUrl().baseUrl}productCrud.php'),
          body: {
            "action": "create",
            "category_id": "$selectedCategoryId",
            "branch_id" : "$selectedBrachId",
            "name": _txtName.text.toString(),
            "description": _txtDescription.text.toString(),
            "price": "${parseRupiah(_txtPrice.text.toString())}",
            "stock": _txtStock.text.toString(),
            "image": "$_base64Image",
          },
        );
        print("::");

      } else {
        if(_base64Image==null){
          res = await http.post(
            Uri.parse('${ApiUrl().baseUrl}productCrud.php'),
            body: {
              "action": "update",
              "id": widget.item!.id,
              "category_id": "$selectedCategoryId",
              "branch_id" : "$selectedBrachId",
              "name": _txtName.text.toString(),
              "description": _txtDescription.text.toString(),
              "price": "${parseRupiah(_txtPrice.text.toString())}",
              "stock": _txtStock.text.toString(),
            },
          );
        }else{
          res = await http.post(
            Uri.parse('${ApiUrl().baseUrl}productCrud.php'),
            body: {
              "action": "update",
              "id": widget.item!.id,
              "category_id": "$selectedCategoryId",
              "branch_id" : "$selectedBrachId",
              "name": _txtName.text.toString(),
              "description": _txtDescription.text.toString(),
              "price": "${parseRupiah(_txtPrice.text.toString())}",
              "stock": _txtStock.text.toString(),
              "image": "$_base64Image",
            },
          );
        }
      }
      print("::");

      ModelBase data = modelBaseFromJson(res.body);

      if (data.isSuccess == true) {
        print("$selectedCategoryId\n${_txtName.text}\n${selectedBrachId}\n${_txtStock.text}\n${parseRupiah(_txtPrice.text)}\n${_txtDescription.text}\n$_base64Image");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );

        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => ProductListPage()),
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
        SnackBar(content: Text('Error:: ${e.toString()}')),
      );
      setState(() {
        isLoading = false;
      });
    }

    return null;
  }

  Future<ModelBase?> deleteProduct() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}productCrud.php'),
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
            MaterialPageRoute(builder: (context) => ProductListPage()),
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

  Future<List<category.Datum>?> getCategory() async {
    try {
      http.Response res = await http.get(Uri.parse('${ApiUrl().baseUrl}category.php'));

      var categoryResponse = category.modelCategoryFromJson(res.body);

      if (categoryResponse.isSuccess == true) {
        print("Data diperoleh :: ${categoryResponse.data?.length}");
        List<category.Datum>? result = categoryResponse.data;
        if (result != null) {
          setState(() {
            optionsCategory = result;
            if (optionsCategory.isNotEmpty && widget.item == null) {
              dropdownValueCategory = optionsCategory.first.nameCategory;
            }
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
    _futureBranch = getBranch();
    _futureCategory = getCategory();
    if (widget.item != null) {
      _txtName.text = widget.item!.name!;
      _txtPrice.text = widget.item!.price!;
      _txtStock.text = widget.item!.stock!;
      _txtDescription.text = widget.item!.description!;
      selectedBrachId = widget.item!.branchId!;
      selectedCategoryId = widget.item!.categoryId!;
    } else {
      _txtName.clear();
      _txtDescription.clear();
      _txtPrice.clear();
      _txtStock.clear();
    }
  }

  int parseRupiah(String rupiahStr) {
    // Hapus "Rp " dan "." dari string
    String cleanedStr = rupiahStr.replaceAll(RegExp(r'[^0-9]'), '');

    // Ubah string menjadi integer
    int parsedValue = int.parse(cleanedStr);

    return parsedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Product',
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 180),
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
                          icon: Icon(Icons.chevron_right_rounded),
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
                            selectedBrachId = selectedDatum.id;
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
              Text("Select Image"),
              Column(
                children: <Widget>[
                  _image == null
                      ? widget.item==null
                        ?Text('No image selected.')
                        : Image.network(
                            height: 200,
                            width: 200,
                            "${ApiUrl().baseUrl}image/${widget.item!.image!}",
                          )
                      : Image.file(
                    _image!,
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.photo_camera),
                        onPressed: () => _pickImage(ImageSource.camera),
                      ),
                      IconButton(
                        icon: Icon(Icons.photo_library),
                        onPressed: () => _pickImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Text("Product Name"),
              CustomTextField(hintText: "product", controller: _txtName),
              SizedBox(height: 20),
              Text("Category"),
              FutureBuilder<List<category.Datum>?>(
                future: _futureCategory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No Data Available');
                  } else {
                    if (widget.item != null && dropdownValueCategory == null) {
                      // Set dropdownValue jika item tidak null dan dropdownValue belum diatur
                      category.Datum? selectedDatum = optionsCategory.firstWhere(
                            (datum) => datum.id == widget.item!.categoryId,
                        orElse: () => optionsCategory.first,
                      );
                      dropdownValueCategory = selectedDatum.nameCategory;
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
                          value: dropdownValueCategory,
                          icon: Icon(Icons.chevron_right_rounded),
                          isExpanded: true,
                          iconSize: 24,
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
                          },
                          items: optionsCategory.map<DropdownMenuItem<String>>((category.Datum value) {
                            return DropdownMenuItem<String>(
                              value: value.nameCategory,
                              child: Text(value.nameCategory ?? ''),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Text("Deskription"),
              CustomTextField(hintText: "Deskription", controller: _txtDescription),
              SizedBox(height: 20),
              RupiahInputWidget(controller: _txtPrice,),
              SizedBox(height: 20),
              Text("Stock"),
              CustomTextField(hintText: "Stock", controller: _txtStock)

            ],
          ),
        )
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
                    deleteProduct();
                  },
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  label: isLoading == true
                      ? CircularProgressIndicator()
                      : Text(
                    'Delete Product',
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
                  addProduct();
                  // print("$_base64Image");
                },
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10), // Sudut melengkung
                ),
                label: isLoading == true
                    ? CircularProgressIndicator()
                    : Text(
                  widget.item == null ? 'Add New Product' : 'Update Product',
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
