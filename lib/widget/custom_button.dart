import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String hint;
  final Color backgroundColor;
  final Color textColor;

  const CustomButton({
    Key? key,
    required this.hint,
    required this.backgroundColor,
    required this.textColor,
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
        child: Text(
          hint,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
