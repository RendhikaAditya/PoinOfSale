import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/model/modelLoginEmployee.dart';
import 'package:poinofsale/widget/custom_button.dart';
import 'package:poinofsale/widget/custom_text_field.dart';
import 'package:poinofsale/widget/password_text_field.dart';
import 'package:http/http.dart' as http;

import '../../utils/apiUrl.dart';
import '../../utils/sesionManager.dart';
import '../main/homePage.dart';

class LoginEmployeePage extends StatefulWidget {
  const LoginEmployeePage({super.key});

  @override
  State<LoginEmployeePage> createState() => _LoginEmployeePageState();
}

class _LoginEmployeePageState extends State<LoginEmployeePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool? isLoading;

  Future<ModelLoginEmployee?> loginUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(
        Uri.parse('${ApiUrl().baseUrl}loginEmployee.php'),
        body: {
          "username": _usernameController.text,
          "password": _passwordController.text
        },
      );

      ModelLoginEmployee data = modelLoginEmployeeFromJson(res.body);
      print(data);

      if (data.isSuccess==true) {
        sessionManager.saveSession(
            true,
            data.data!.id.toString(),
            data.data!.username.toString(),
            "Employee",
            data.data!.branchId.toString()
        );
        sessionManager.getSession();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${data.message}')),
        );



        setState(() {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log in as Employee",
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white12,
            borderRadius: BorderRadius.circular(10.0), // Radius sudut
          ),
          child: IconButton(
            icon: Center(child: Icon(Icons.arrow_back_ios, color: Colors.blue),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Username"),
            CustomTextField(hintText: "Username", controller: _usernameController),
            SizedBox(height: 20,),
            Text("Password"),
            PasswordTextField(hintText: "Password", controller: _passwordController),
            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Text(
                "Use the cashier username that can be created by the Owner in Manage Store -> Employee"
              ),
            ),
            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                loginUser();
              },
              child:CustomButton(
                hint: "Log in",
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              )
            )
          ],
        ),
      ),
    );
  }
}
