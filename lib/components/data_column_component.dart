import 'package:flutter/material.dart';

class DataColumnComponent {
  String title;
  DataColumnComponent(this.title);

  DataColumn create() {
    return DataColumn(
      label: Text(
        title,
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}
