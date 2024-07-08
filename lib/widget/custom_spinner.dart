import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomSpinner extends StatefulWidget {
  @override
  _CustomSpinnerState createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner> {
  String dropdownValue = 'Option 1';
  List<String> options = ['Option 1', 'Option 2', 'Option 3', 'Option 4'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownValue,
            icon: Icon(Icons.arrow_downward),
            isExpanded: true,
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.black, fontSize: 16),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}