import 'package:expensetracker/components/data_column_component.dart';
import 'package:expensetracker/components/data_row_component.dart';
import 'package:expensetracker/components/rounded_button_component.dart';
import 'package:expensetracker/components/side_navbar_component.dart';
import 'package:expensetracker/models/expense_date.dart';
import 'package:expensetracker/models/expense_date_list.dart';
import 'package:expensetracker/models/expense_item.dart';
import 'package:expensetracker/models/expense_item_list.dart';
import 'package:expensetracker/services/data_storage_service.dart';
import 'package:expensetracker/utils/constants.dart';
import 'package:expensetracker/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:after_init/after_init.dart';
import 'dart:convert';

class ExpenseScreen extends StatefulWidget {
  static const String id = "expense_screen";

  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen>
    with AfterInitMixin<ExpenseScreen> {
  TextEditingController textController = TextEditingController();

  String expenseCategory;
  double expenseValue;
  double totalBalance;

  Map<String, double> totalExpenses = Map.fromIterables(
      Constants.categoryList, List.filled(Constants.categoryList.length, 0));

  ExpenseDateList expenseDateList = ExpenseDateList();
  ExpenseItemList expenseItemList = ExpenseItemList();

  void _loadSettingsData() {
    Settings.currency =
        DataStorage.loadData(Constants.currencyStorageKey) ?? '';
    Settings.language =
        DataStorage.loadData(Constants.languageStorageKey) ?? '';
    Settings.balance = DataStorage.loadData(Constants.balanceStorageKey) ?? '';
    print(Settings.balance);
    totalBalance = (Settings.balance == '' || Settings.balance == null)
        ? 0
        : double.parse(Settings.balance.replaceAll(',', '.'));
  }

  void _loadExpenseData() {
    String savedData = DataStorage.loadData(Constants.dataStorageKey);

    if (savedData != null) {
      dynamic savedDataJson = json.decode(savedData);

      for (dynamic expenseDateListItem
          in savedDataJson[Constants.expenseDateListKey]) {
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
        expenseDateList.addExpenseDate(expenseDate);
      }
    }
  }

  void _saveExpenseData() {
    if (expenseCategory == null || expenseValue == null) {
      return;
    }

    if (expenseCategory == Constants.categoryList[0]) {
      totalBalance += expenseValue;
    } else {
      totalBalance -= expenseValue;
    }
    Settings.balance = totalBalance.toString();

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

    DataStorage.saveData(
        Constants.dataStorageKey, expenseDateList.toJson().toString());

    DataStorage.saveData(Constants.balanceStorageKey, Settings.balance);

    totalExpenses[expenseCategory] += expenseValue;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didInitState() async {
    await DataStorage.init();

    setState(() {
      _loadSettingsData();
      _loadExpenseData();
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.kAppbarStyle,
      drawer: SideNavBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                'Expenses',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Your Balance: $totalBalance ${Settings.currency}',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 20,
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
            flex: 2,
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
      dataRows.add(DataRowComponent(
        expenseItem.getIconData(),
        expenseItem.getCategory(),
        expenseItem.getValue(),
        Settings.currency,
      ).create());
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
