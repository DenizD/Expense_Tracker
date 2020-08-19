import 'package:currencies/currencies.dart';
import 'package:expensetracker/components/custom_dropdown_component.dart';
import 'package:expensetracker/components/side_navbar_component.dart';
import 'package:expensetracker/services/data_storage_service.dart';
import 'package:expensetracker/utils/constants.dart';
import 'package:expensetracker/utils/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = "settings_screen";

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<DropdownMenuItem> currencyItems = [];
  final List<DropdownMenuItem> languageItems = [];
  TextEditingController textController = TextEditingController();

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
    textController.text = '${Settings.balance} ${Settings.currency}';
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
            flex: 2,
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
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Balance',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Set your balance',
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.left,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    onSubmitted: (String value) {
                      Settings.balance = value;
                      setState(() {
                        textController.text =
                            '${Settings.balance} ${Settings.currency}';
                        DataStorage.saveData(
                            Constants.balanceStorageKey, Settings.balance);
                      });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
