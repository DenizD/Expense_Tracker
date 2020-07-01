import 'package:flutter/material.dart';

class Constants {
  static final String dataStorageKey = 'expense_tracker';
  static final String expenseItemKey = 'expenseItem';
  static final String expenseItemCategoryKey = 'category';
  static final String expenseItemValueKey = 'value';
  static final String expenseItemListKey = 'expenseItemList';
  static final String expenseDateKey = 'expenseDate';
  static final String expenseDateListKey = 'expenseDateList';

  static final List<String> categories = [
    'Home',
    'Car',
    'Shopping',
    'Restaurant',
    'Leisure',
    'Other',
  ];

  static final List<IconData> icons = [
    Icons.home,
    Icons.directions_car,
    Icons.shopping_cart,
    Icons.restaurant,
    Icons.beach_access,
    Icons.toys,
  ];

  static final Map<String, IconData> categoryIcons =
      Map.fromIterables(categories, icons);
}
