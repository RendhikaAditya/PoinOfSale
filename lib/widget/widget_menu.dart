import 'package:flutter/material.dart';

class WidgeteMenu extends StatelessWidget {
  final String title;
  final Function navigatorPush;

  const WidgeteMenu({
    required this.title,
    required this.navigatorPush,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        navigatorPush();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "$title",
              ),
            ),
            Icon(Icons.keyboard_arrow_right_rounded), // Icon panah ke kanan
          ],
        ),
      ),
    );
  }
}
