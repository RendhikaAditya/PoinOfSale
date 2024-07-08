import 'package:flutter/material.dart';
import 'dart:math';

class ItemReportPaymentWidget extends StatelessWidget {
  final String payment;
  final String sales;
  final String presentase;

  const ItemReportPaymentWidget({
    Key? key,
    required this.payment,
    required this.sales,
    required this.presentase,
  }) : super(key: key);

  Color getRandomColor() {
    final random = Random();
    final primaryColors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.cyan,
    ];
    return primaryColors[random.nextInt(primaryColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final progressBarColor = getRandomColor();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    sales,
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    presentase,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: getRandomColor(),
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
