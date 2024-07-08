import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/utils/sesionManager.dart';
import 'package:poinofsale/view/auth/selectLoginPage.dart';
import 'package:poinofsale/view/profile/editEmployee.dart';
import 'package:poinofsale/widget/custom_button.dart';
import 'package:poinofsale/widget/widget_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Account',
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("images/img_account.png"),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(sessionManager.username.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                    Text(sessionManager.role.toString())
                  ],
                )
              ],
            ),
            Divider(),
            WidgeteMenu(title: "Edit Account", navigatorPush: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditEmployee(username: sessionManager.username.toString(), idBranch: sessionManager.idBranch.toString())),
              );            }),
            Divider(),

          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.maxFinite,
        padding: EdgeInsets.only(top: 100),
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => SelectLoginPage()),
                  (route) => false,
            );
          },
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // Sudut melengkung
          ),
          label: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Log Out', style: TextStyle(color: Colors.white), textAlign: TextAlign.start,),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}
