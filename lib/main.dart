import 'package:expensetracker/screens/expense_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpenseScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
