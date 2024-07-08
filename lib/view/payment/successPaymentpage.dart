import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/view/main/homePage.dart';
import 'package:poinofsale/widget/custom_button.dart';
import 'package:poinofsale/widget/custom_text_field.dart';

class SuccessPage extends StatefulWidget {
  final String totalPrice;
  final String paymentMethod;
  const SuccessPage({super.key, required this.totalPrice, required this.paymentMethod});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: EdgeInsets.only(top:50,left: 20,right: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16,),
            Image.asset("images/ic_success.png"),
            SizedBox(height: 16,),
            Text("Successfull Transaction!", style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 24),),
            SizedBox(height: 8,),
            Text("Note : Do not forget to give smile to customers.", style: TextStyle(color: Colors.grey,fontSize: 12),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50,vertical: 16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.blue
              ),
              child: Column(
                children: [
                  SizedBox(height: 8,),
                  Text("Method Payment : ${widget.paymentMethod}",style: TextStyle(color: Colors.white)),
                  Divider(),
                  Text("Money Changes : ${widget.totalPrice}",style: TextStyle(color: Colors.white),),
                  SizedBox(height: 8,),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  CustomTextField(hintText: "Email", controller: _emailController),
                  SizedBox(height: 10,),
                  CustomButton(hint: "SEND RECEIPT", backgroundColor: Color.fromARGB(255, 233, 241,252), textColor: Colors.blue),
                  SizedBox(height: 20,),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: FloatingActionButton.extended(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    onPressed: () {
                      // Aksi pertama
                    },
                    label: Text('PRINT RECEIPT', style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Jarak antara dua FAB
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: FloatingActionButton.extended(
                  onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                HomePage()),
                      );

                  },
                  label: Text('NEXT ORDER', style: TextStyle(color: Colors.blue, fontSize: 18),),
                  backgroundColor: Colors.blue[100],
                  elevation: 0,
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
