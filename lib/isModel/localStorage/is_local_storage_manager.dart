import 'package:shared_preferences/shared_preferences.dart';

class ISLocalStorageManager {
  static const String LOCALSTORAGE_PREFIX = "INSURANCE.LOCALSTORAGE";

  static saveGlobalObject(String? data, String keySuffix) async {
    final String key = LOCALSTORAGE_PREFIX + "." + keySuffix;
    final prefs = await SharedPreferences.getInstance();
    if (data == null) {
      prefs.remove(key);
    } else {
      prefs.setString(key, data);
    }
  }

  static Future<String?>? loadGlobalObjectForKey(String keySuffix) async {
    final String key = LOCALSTORAGE_PREFIX + "." + keySuffix;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static deleteGlobalObject(String keySuffix) async {
    final String key = LOCALSTORAGE_PREFIX + "." + keySuffix;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

}