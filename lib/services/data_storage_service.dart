import 'package:shared_preferences/shared_preferences.dart';

class DataStorage {
  static SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void saveData(String key, String data) {
    prefs.setString(key, data);
  }

  static String loadData(String key) {
    if (prefs.containsKey(key)) {
      String data = prefs.getString(key);
      return data;
    }
    return null;
  }

  static void deleteData(String key) {
    if (prefs.containsKey(key)) {
      prefs.remove(key);
    }
  }
}
