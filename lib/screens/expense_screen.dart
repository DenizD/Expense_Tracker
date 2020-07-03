import 'dart:math';

import 'package:expensetracker/components/data_column_component.dart';
import 'package:expensetracker/components/data_row_component.dart';
import 'package:expensetracker/components/rounded_button_component.dart';
import 'package:expensetracker/models/expense_date.dart';
import 'package:expensetracker/models/expense_date_list.dart';
import 'package:expensetracker/models/expense_item.dart';
import 'package:expensetracker/models/expense_item_list.dart';
import 'package:expensetracker/services/data_storage_service.dart';
import 'package:expensetracker/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  TextEditingController textController = TextEditingController();

  String expenseCategory;
  double expenseValue;

  Map<String, double> totalExpenses = Map.fromIterables(
      Constants.categoryList, List.filled(Constants.categoryList.length, 0));

  ExpenseDateList expenseDateList = ExpenseDateList();
  ExpenseItemList expenseItemList = ExpenseItemList();

  DataStorage dataStorage = DataStorage();

  Future<void> _loadExpenseData() async {
    await dataStorage.init();

    dynamic savedData = dataStorage.loadData(Constants.dataStorageKey);

    if (savedData != null) {
      for (dynamic expenseDateListItem
          in savedData[Constants.expenseDateListKey]) {
        String savedExpenseDate = expenseDateListItem[Constants.expenseDateKey];
        ExpenseItemList savedExpenseItemList = ExpenseItemList();
        if (savedExpenseDate == DateFormat('yyyy-MM').format(DateTime.now())) {
          expenseItemList = savedExpenseItemList;
        }
        for (dynamic savedExpenseItem
            in expenseDateListItem[Constants.expenseItemListKey]) {
          String savedExpenseItemCategory =
              savedExpenseItem[Constants.expenseItemCategoryKey];
          double savedExpenseItemValue =
              savedExpenseItem[Constants.expenseItemValueKey];
          IconData savedExpenseItemIcon = Constants.categoryIconMap[
              savedExpenseItem[Constants.expenseItemCategoryKey]];
          savedExpenseItemList.addExpenseItem(ExpenseItem(
            savedExpenseItemCategory,
            savedExpenseItemValue,
            savedExpenseItemIcon,
          ));
          totalExpenses[savedExpenseItemCategory] += savedExpenseItemValue;
        }
        ExpenseDate expenseDate = ExpenseDate(
            DateTime.parse(savedExpenseDate.toString() + '-01'),
            savedExpenseItemList);
        setState(() {
          expenseDateList.addExpenseDate(expenseDate);
        });
      }
    }
  }

  void _saveExpenseData() {
    if (expenseCategory == null || expenseValue == null) {
      return;
    }
    ExpenseItem expenseItem = ExpenseItem(
      expenseCategory,
      expenseValue,
      Constants.categoryIconMap[expenseCategory],
    );
    expenseItemList.addExpenseItem(expenseItem);

    ExpenseDate expenseDate = ExpenseDate(
      DateTime.now(),
      expenseItemList,
    );
    expenseDateList.addExpenseDate(expenseDate);

    dataStorage.saveData(
        Constants.dataStorageKey, expenseDateList.toJson().toString());

    totalExpenses[expenseCategory] += expenseValue;
  }

  @override
  void initState() {
    super.initState();
    _loadExpenseData();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Expense Tracker'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: ListView.builder(
              itemCount: expenseDateList.getExpenseDateList().length ?? 0,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                      '${expenseDateList.getExpenseDateList()[index].getFormattedDate()}'),
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.green),
                      child: Column(
                        children: _buildExpandableTable(expenseDateList
                            .getExpenseDateList()[index]
                            .getExpenseItemList()),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RoundedButton(
                  iconData: Icons.pie_chart_outlined,
                  onPressed: () {
                    _showTotalExpensesScreen();
                  },
                ),
                RoundedButton(
                  iconData: Icons.add,
                  onPressed: _showAddExpenseScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandableTable(ExpenseItemList expenseItemList) {
    List<Widget> tableContent = [];
    List<DataColumn> dataColumns = [
      DataColumnComponent('').create(),
      DataColumnComponent('Category').create(),
      DataColumnComponent('Expense').create()
    ];

    List<DataRow> dataRows = [];
    expenseItemList.sortExpenseItems();
    for (ExpenseItem expenseItem in expenseItemList.getExpenseItemList()) {
      dataRows.add(DataRowComponent(expenseItem.getIconData(),
              expenseItem.getCategory(), expenseItem.getValue())
          .create());
    }

    tableContent.add(
      DataTable(
        columns: dataColumns,
        rows: dataRows,
      ),
    );

    return tableContent;
  }

  void _showAddExpenseScreen() {
    expenseCategory = null;
    expenseValue = null;

    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add Expense',
            style: TextStyle(color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                DropdownButtonFormField<String>(
                  value: expenseCategory,
                  hint: Text('Category'),
                  items: Constants.categoryList.map((String selectedValue) {
                    return DropdownMenuItem<String>(
                      value: selectedValue,
                      child: Text(selectedValue),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      expenseCategory = value;
                    });
                  },
                ),
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: "Enter expense",
                  ),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                try {
                  expenseValue =
                      double.parse(textController.text.replaceAll(',', '.'));
                } catch (error) {
//                  print(error);
                }
                textController.clear();
                setState(() {
                  _saveExpenseData();
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                textController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showTotalExpensesScreen() {
    showDialog(
      context: context, barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Expense Distribution',
            style: TextStyle(color: Colors.green),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            child: PieChart(
              dataMap: totalExpenses,
              colorList: Constants.categoryColorList,
              legendPosition: LegendPosition.bottom,
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
