import 'package:currencies/currencies.dart';
import 'package:expensetracker/components/custom_dropdown_component.dart';
import 'package:expensetracker/components/side_navbar_component.dart';
import 'package:expensetracker/services/data_storage_service.dart';
import 'package:expensetracker/utils/constants.dart';
import 'package:expensetracker/utils/settings.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = "settings_screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<DropdownMenuItem> currencyItems = [];
  final List<DropdownMenuItem> languageItems = [];

  void _addCurrencies() {
    for (Currency currency in Constants.currencyList) {
      currencyItems.add(DropdownMenuItem(
        child: Text('${currency.isoCode}'),
        value: currency.symbol,
      ));
    }
  }

  void _addLanguages() {
    for (String language in Constants.languageList) {
      languageItems.add(DropdownMenuItem(
        child: Text(language),
        value: language,
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _addCurrencies();
    _addLanguages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Constants.kAppbarStyle,
      drawer: SideNavBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Settings',
                style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Currency',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                CustomDropdown(
                  hintText: 'Select currency',
                  dropdownItems: currencyItems,
                  selectedValue: Settings.currency,
                  onChanged: (value) {
                    setState(() {
                      Settings.currency = value;
                      DataStorage.saveData(
                          Constants.currencyStorageKey, Settings.currency);
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Language',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                CustomDropdown(
                  hintText: 'Select language',
                  dropdownItems: languageItems,
                  selectedValue: Settings.language,
                  onChanged: (value) {
                    setState(() {
                      Settings.language = value;
                      DataStorage.saveData(
                          Constants.languageStorageKey, Settings.language);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
