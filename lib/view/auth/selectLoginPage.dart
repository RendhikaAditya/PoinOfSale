import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:poinofsale/view/auth/loginEmployeePage.dart';
import 'package:poinofsale/view/auth/loginOwnerPage.dart';
import 'package:poinofsale/widget/custom_button_icon.dart';

class SelectLoginPage extends StatefulWidget {
  const SelectLoginPage({super.key});

  @override
  State<SelectLoginPage> createState() => _SelectLoginPageState();
}

class _SelectLoginPageState extends State<SelectLoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Log in",
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
            Text("Welcome to MokPOS", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 20),),
            Text("Select login as the owner or employee first to continue.", style: TextStyle(color: Colors.black),),
            SizedBox(height: 60,),
            Center(child: Image.asset("images/img_login.png", height: 150,),),
            SizedBox(height: 60,),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginOwnerPage()),
                );
              },
              child: CustomButtonIcon(
                  hint: "Log in as Owner",
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  icon: Icons.person,
                  iconColor: Colors.white
              ),
            ),
            SizedBox(height: 10,),
            Center(child: Text("or", style: TextStyle(color: Colors.black),),),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          LoginEmployeePage()),
                );
              },
              child: CustomButtonIcon(
                  hint: "Log in as Employee",
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  icon: Icons.perm_contact_calendar_rounded,
                  iconColor: Colors.white
              ),
            ),
          ],
        ),
      ),
    );

  }
}
