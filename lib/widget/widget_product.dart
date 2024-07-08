import 'package:flutter/material.dart';

class WidgetProduct extends StatelessWidget {
  final String title;
  final String subtitle1;
  final String subtitle2;
  final String imageUrl;
  final Function navigatorPush;

  const WidgetProduct({
    required this.title,
    required this.subtitle1,
    required this.subtitle2,
    required this.imageUrl,
    required this.navigatorPush,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorPush();
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: Colors.grey),
        ),
        child: Row(
          children: [
            imageUrl.isNotEmpty?Image.network(
              imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ):Text("data"),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle1,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    subtitle2,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_right_rounded), // Icon panah ke kanan
          ],
        ),
      ),
    );
  }
}
