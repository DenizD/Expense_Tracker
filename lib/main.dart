import 'package:expensetracker/screens/expense_screen.dart';
import 'package:expensetracker/screens/settings_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTracker());
}

class ExpenseTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ExpenseScreen.id,
      routes: {
        ExpenseScreen.id: (context) => ExpenseScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
