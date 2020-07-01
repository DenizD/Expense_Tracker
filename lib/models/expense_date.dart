import 'package:expensetracker/models/expense_item.dart';
import 'package:expensetracker/models/expense_item_list.dart';
import 'package:expensetracker/utils/constants.dart';
import 'package:intl/intl.dart';

class ExpenseDate {
  DateTime _dateTime;
  ExpenseItemList _expenseItemList;

  ExpenseDate(DateTime dateTime, ExpenseItemList expenseItemList) {
    _dateTime = dateTime;
    _expenseItemList = expenseItemList;
  }

  DateTime getDateTime() {
    return _dateTime;
  }

  String getFormattedDate() {
    return DateFormat('yyyy-MM').format(_dateTime);
  }

  ExpenseItemList getExpenseItemList() {
    return _expenseItemList;
  }

  void setDateTime(DateTime dateTime) {
    _dateTime = dateTime;
  }

  void setExpenseItemList(ExpenseItemList expenseItemList) {
    _expenseItemList = expenseItemList;
  }

  Map toJson() {
    Map jsonData = {
      '\"${Constants.expenseDateKey}\"': '\"' + getFormattedDate() + '\"',
      '\"${Constants.expenseItemListKey}\"': '[',
    };

    for (int ii = 0; ii < _expenseItemList.getExpenseItemList().length; ii++) {
      ExpenseItem expenseItem = _expenseItemList.getExpenseItemList()[ii];
      if (ii > 0) {
        jsonData['\"${Constants.expenseItemListKey}\"'] += ',';
      }
      jsonData['\"${Constants.expenseItemListKey}\"'] +=
          expenseItem.toJson().toString();
    }

    jsonData['\"${Constants.expenseItemListKey}\"'] += ']';

    return jsonData;
  }
}
