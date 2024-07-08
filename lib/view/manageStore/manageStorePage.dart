import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/view/main/homePage.dart';
import 'package:poinofsale/view/manageStore/branch/branchListPage.dart';
import 'package:poinofsale/view/manageStore/category/categoryListPage.dart';
import 'package:poinofsale/view/manageStore/customer/customerListPage.dart';
import 'package:poinofsale/view/manageStore/employe/employeeListPage.dart';
import 'package:poinofsale/view/manageStore/product/productListPage.dart';
import 'package:poinofsale/widget/widget_menu.dart';

class ManageStorePage extends StatefulWidget {
  const ManageStorePage({super.key});

  @override
  State<ManageStorePage> createState() => _ManageStorePageState();
}

class _ManageStorePageState extends State<ManageStorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Padding(padding: EdgeInsets.only(right: 50),child: Text('Manage Store', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),),),
        leading: IconButton(
          icon: Center(child: Icon(Icons.arrow_back, color: Colors.blue),),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
                  (route) => false,
            );
          },
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Set Product",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            WidgeteMenu(title: "Product", navigatorPush: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductListPage()),
              );
            }),
            Divider(),
            WidgeteMenu(title: "Category Product", navigatorPush: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CategoryListPage()),
              );
            }),
            Divider(),
            SizedBox(height: 10,),
            Text("Set Branch & Employee",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            WidgeteMenu(title: "Branch", navigatorPush: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BranchListPage()),
              );
            }),
            Divider(),
            WidgeteMenu(title: "Employee", navigatorPush: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EmployeListPage()),
              );
            }),
            Divider(),
            WidgeteMenu(title: "Customer", navigatorPush: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        CustomerListPage()),
              );
            }),
          ],
        ),
      ),
    );
  }
}
