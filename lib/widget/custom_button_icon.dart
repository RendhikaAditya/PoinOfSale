import 'package:flutter/material.dart';

class CustomButtonIcon extends StatelessWidget {
  final String hint;
  final Color backgroundColor;
  final Color textColor;
  final IconData icon;
  final Color iconColor;

  const CustomButtonIcon({
    Key? key,
    required this.hint,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
    required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      padding: EdgeInsets.all(18.0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: iconColor,
            ),
            SizedBox(width: 8.0),
            Text(
              hint,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
