import 'package:expensetracker/models/expense_item.dart';

class ExpenseItemList {
  List<ExpenseItem> _expenseItemList = [];
  Map<String, ExpenseItem> _expenseItemMap = {};

  List<ExpenseItem> getExpenseItemList() {
    return _expenseItemList;
  }

  void addExpenseItem(ExpenseItem expenseItem) {
    _expenseItemMap.update(expenseItem.getCategory(), (existingValue) {
      if (expenseItem.getCategory() == existingValue.getCategory()) {
        expenseItem.setValue(expenseItem.getValue() + existingValue.getValue());
      }
      return expenseItem;
    }, ifAbsent: () => expenseItem);

    _expenseItemList = _expenseItemMap.values.toList();
  }
}
