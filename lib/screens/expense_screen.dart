import 'package:expensetracker/models/expense_date.dart';
import 'package:expensetracker/models/expense_date_list.dart';
import 'package:expensetracker/models/expense_item.dart';
import 'package:expensetracker/models/expense_item_list.dart';
import 'package:expensetracker/services/data_storage_service.dart';
import 'package:expensetracker/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  final textController = TextEditingController();

  String expenseCategory;
  double expenseValue;

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
        for (dynamic expenseItem
            in expenseDateListItem[Constants.expenseItemListKey]) {
          savedExpenseItemList.addExpenseItem(ExpenseItem(
            expenseItem[Constants.expenseItemCategoryKey],
            expenseItem[Constants.expenseItemValueKey],
            Constants
                .categoryIcons[expenseItem[Constants.expenseItemCategoryKey]],
          ));
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
    try {
      expenseValue = double.parse(textController.text.replaceAll(',', '.'));
      expenseItemList.addExpenseItem(
        ExpenseItem(
          expenseCategory,
          expenseValue,
          Constants.categoryIcons[expenseCategory],
        ),
      );

      expenseDateList.addExpenseDate(
        ExpenseDate(
          DateTime.now(),
          expenseItemList,
        ),
      );

      dataStorage.saveData(
          Constants.dataStorageKey, expenseDateList.toJson().toString());
    } catch (error) {
      print(error);
    }
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
        centerTitle: true,
        title: Text('Expense Tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddExpenseScreen();
        },
      ),
      body: ListView.builder(
        itemCount: expenseDateList.getExpenseDateList().length ?? 0,
        itemBuilder: (context, index) {
          return ExpansionTile(
            title: Text(
                '${expenseDateList.getExpenseDateList()[index].getFormattedDate()}'),
            children: <Widget>[
              Column(
                children: _buildExpandableTable(expenseDateList
                    .getExpenseDateList()[index]
                    .getExpenseItemList()),
              ),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildExpandableTable(ExpenseItemList expenseItemList) {
    List<Widget> columnContent = [];

    columnContent.add(
      DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Category',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Expense',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ],
        rows: <DataRow>[
          for (ExpenseItem expenseItem in expenseItemList.getExpenseItemList())
            DataRow(
              cells: <DataCell>[
                DataCell(Icon(expenseItem.getIconData())),
                DataCell(Text('${expenseItem.getCategory()}')),
                DataCell(Text('${expenseItem.getValue()}')),
              ],
            ),
        ],
      ),
    );

    return columnContent;
  }

  void _showAddExpenseScreen() {
    expenseCategory = null;
    expenseValue = null;
    textController.text = '';

    showDialog(
      context: context, barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Expense Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                DropdownButtonFormField<String>(
                  value: expenseCategory,
                  hint: Text('Category'),
                  items: Constants.categories.map((String selectedValue) {
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
                  decoration: InputDecoration(labelText: "Enter expense"),
                  keyboardType: TextInputType.number,
                  onChanged: (text) => {},
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                setState(() {
                  _saveExpenseData();
                });
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Cancel'),
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
