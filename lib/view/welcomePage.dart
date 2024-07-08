import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poinofsale/view/auth/selectLoginPage.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("images/img_welcome.png", height: 200,),
            SizedBox(height: 20,),
            Text("Easy Management for your store",style: TextStyle(color: Colors.black87,fontWeight: FontWeight.bold),)
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16), // Jarak antara dua FAB
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blue, // Warna border biru
                      width: 2.0, // Ketebalan border
                    ),
                    borderRadius: BorderRadius.circular(8.0), // Sesuaikan dengan border radius dari tombol
                  ),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                SelectLoginPage()),
                      );

                    },
                    label: Text('Log in', style: TextStyle(color: Colors.blue, fontSize: 18)),
                    backgroundColor: Colors.white,
                    elevation: 0,
                  ),
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
