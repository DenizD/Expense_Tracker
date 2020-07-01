import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DataStorage {
  SharedPreferences prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  void saveData(String key, String data) {
    prefs.setString(key, data);
  }

  dynamic loadData(key) {
    if (prefs.containsKey(key)) {
      String data = prefs.getString(key);
      dynamic jsonData = json.decode(data);

      return jsonData;
    }
    return null;
  }
}
