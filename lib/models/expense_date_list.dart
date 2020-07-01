import 'package:expensetracker/models/expense_date.dart';
import 'package:expensetracker/utils/constants.dart';

class ExpenseDateList {
  List<ExpenseDate> _expenseDateList = [];
  Map<String, ExpenseDate> _expenseDateMap = {};

  List<ExpenseDate> getExpenseDateList() {
    return _expenseDateList;
  }

  void addExpenseDate(ExpenseDate expenseDate) {
    _expenseDateMap.update(expenseDate.getDateTime().month.toString(),
        (existingValue) => expenseDate,
        ifAbsent: () => expenseDate);

    _expenseDateList = _expenseDateMap.values.toList();
  }

  Map toJson() {
    Map jsonData = {
      '\"${Constants.expenseDateListKey}\"': '[',
    };

    for (int ii = 0; ii < _expenseDateList.length; ii++) {
      ExpenseDate expenseDate = _expenseDateList[ii];
      if (ii > 0) {
        jsonData['\"${Constants.expenseDateListKey}\"'] += ',';
      }
      jsonData['\"${Constants.expenseDateListKey}\"'] +=
          expenseDate.toJson().toString();
    }

    jsonData['\"${Constants.expenseDateListKey}\"'] += ']';

    return jsonData;
  }
}
