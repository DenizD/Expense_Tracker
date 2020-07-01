import 'package:expensetracker/utils/constants.dart';
import 'package:flutter/material.dart';

class ExpenseItem {
  String _category;
  double _value;
  IconData _iconData;

  ExpenseItem(String category, double value, IconData iconData) {
    _category = category;
    _value = value;
    _iconData = iconData;
  }

  String getCategory() {
    return _category;
  }

  double getValue() {
    return _value;
  }

  IconData getIconData() {
    return _iconData;
  }

  void setCategory(String category) {
    _category = category;
  }

  void setValue(double value) {
    _value = value;
  }

  void setIconData(IconData iconData) {
    _iconData = iconData;
  }

  Map toJson() {
    Map jsonData = {
      '\"${Constants.expenseItemCategoryKey}\"': '\"' + _category + '\"',
      '\"${Constants.expenseItemValueKey}\"': _value,
    };
    return jsonData;
  }
}
