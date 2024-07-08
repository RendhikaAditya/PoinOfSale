import 'package:flutter/material.dart';
import 'dart:math';

class ItemReportWidget extends StatelessWidget {
  final String mainText1;
  final String subText1;
  final String mainText2;
  final String subText2;
  final double progressValue;

  const ItemReportWidget({
    Key? key,
    required this.mainText1,
    required this.subText1,
    required this.mainText2,
    required this.subText2,
    required this.progressValue,
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
                    mainText1,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subText1,
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
                    mainText2,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    subText2,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue/100,
              backgroundColor: Colors.grey[300],
              color: progressBarColor,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }
}
