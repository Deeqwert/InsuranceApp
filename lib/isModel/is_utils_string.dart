import 'dart:convert';
import 'dart:math';

import 'package:insurance/isModel/string_extensions.dart';

class ISUtilsString {
  static bool isEmptyString(String? value) {
    if (value == null) return true;
    return value.isEmpty;
  }

  static String refineString(dynamic sz, {String defValue = ""}) {
    String szResult = defValue;

    if (sz == null) {
      return szResult;
    } else if (sz == "null") return szResult;

    szResult = sz.toString();
    return szResult;
  }
  static String stripNonNumericsFromString(String? text) {
    if (text == null) return "";
    return text.codeUnits
        .map((e) => String.fromCharCode(e))
        .where((element) => isLetterOrDigit(element))
        .join("");
  }
   static String beautifyAmountInDollars(int amount) {
    // $12,345,678
    if (amount <= 0) {
      return "";
    }
    return '\$${amount}'; //$20
  }

   static String stripNonNumberics(String value) {
    if (value == null) {
      return "";
    } else {
      return value.replaceAll("[^0-9.]", "");
    }
  }


  static bool isLetterOrDigit(String s,) =>
      s.contains(RegExp(r'[\da-zA-Z]'));

  static String beautifyPhoneNumber(String? phone) {
    String phoneNumber = stripNonNumericsFromString(phone);
    String szPattern = "(xxx) xxx-xxxx";
    int nMaxLength = szPattern.length;
    String szFormattedNumber = "";
    if (phoneNumber.length > 10) {
      phoneNumber = phoneNumber.substring(phoneNumber.length - 10);
    }
    int index = 0;
    for (int i in Iterable.generate(phoneNumber.length)) {
      int r = szPattern.indexOf("x", index);
      if (r <= 0) break;
      if (r != index) {
        szFormattedNumber += szPattern.substring(index, r);
      }
      szFormattedNumber += phoneNumber.substring(i, i + 1);
      index = r + 1;
    }
    if (phoneNumber.isNotEmpty && (phoneNumber.length < szPattern.length)) {
      int r = szPattern.indexOf("x", szFormattedNumber.length);
      if (r > 0) {
        szFormattedNumber += szPattern.substring(szFormattedNumber.length, r);
      } else {
        szFormattedNumber +=
            szPattern.substring(szFormattedNumber.length, szPattern.length);
      }
    }
    if (szFormattedNumber.length > nMaxLength) {
      szFormattedNumber = szFormattedNumber.substring(0, nMaxLength);
    }
    return szFormattedNumber;
  }

  static double refineDouble(dynamic value, double? defaultValue) {
    double defValue = defaultValue ?? 0.0;

    if (value == null ||
        value.toString().isEmpty ||
        value.toString() == "null" ||
        value == ".") return defValue;

    if (value is double) return value;

    defValue = double.parse(value.toString());
    return defValue;
  }

  static bool refineBool(dynamic value, bool? defaultValue) {
    bool defValue = defaultValue ?? false;

    if (value == null) return defValue;

    if (value is bool) return value;

    defValue = value.toString().toBool();
    return defValue;
  }

  static int refineInt(dynamic value, int? defaultValue) {
    int defValue = defaultValue ?? 0;

    if (value == null || value.toString().isEmpty) return defValue;

    if (value is int) return value;

    defValue = double.parse(value.toString()).round();
    return defValue;
  }

  static String fromDictionary(Map<String, dynamic>? dictionary) {
    // return jsonEncode(dictionary);
    if (dictionary == null) return "{}";
    List<String> contents = [];
    Iterator<String> keys = dictionary.keys as Iterator<String>;
    while (keys.moveNext()) {
      String cKey = keys.current;
      if (dictionary.containsKey(cKey)) {
        dynamic value = dictionary[cKey];
        String? v = getStringForValue(value);
        contents.add("\"$cKey\": $v");
      }
    }
    if (contents.isEmpty) return "{}";
    String result = contents[0];
    for (int i in Iterable.generate(contents.length)) {
      String item = contents[i];
      result = "$result, $item";
    }
    return "{$result}";
  }

  static String? getStringForValue(dynamic value) {
    if (value == null) {
      return null;
    } else if (value is int) {
      return "$value";
    } else if (value is String) {
      String s = value.toString();
      s = s.replaceAll("\n", "\\n");
      return "\"" + s + "\"";
    } else if (value is bool) {
      if (value.toString().toBool()) {
        return "true";
      } else {
        return "false";
      }
    } else if (value is double) {
      return "$value";
    } else if (value is List<dynamic>) {
      List<String?> arrayString = [];
      List<dynamic> arr = value;

      for (int i in Iterable.generate(arr.length)) {
        dynamic obj = arr[i];
        arrayString.add(getStringForValue(obj));
      }
      if (arrayString.isEmpty) return "[]";
      dynamic result = arrayString[0];
      for (int i in Iterable.generate(arrayString.length)) {
        if (i == 0) continue;
        dynamic item = arrayString[i];
        result = "$result, $item";
      }
      return '[' + result + ']';
    } else if (value is List<Map<String, dynamic>>) {
      List<String?> arrayString = [];
      for (int i in Iterable.generate(value.length)) {
        dynamic obj = value[i];
        arrayString.add(getStringForValue(obj));
      }
      if (arrayString.isEmpty) return "[]";
      dynamic result = arrayString[0];
      for (int i in Iterable.generate(arrayString.length)) {
        if (i == 0) continue;
        dynamic item = arrayString[i];
        result = "$result, $item";
      }
      return '[' + result + ']';
    } else if (value is Map<String, dynamic>) {
      return fromDictionary(value);
    }
    return value.toString();
  }

  static Map<String, dynamic>? toDictionary(String text) {
    try {
      return jsonDecode(text);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static String generateRandomString(int length) {
    String letters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => letters.codeUnitAt(_rnd.nextInt(letters.length))));
  }

  static String getInitialsFromName(String name) {
    if (name.length <= 2) {
      return name.toUpperCase();
    }
    List<String> splinted = name.split(" ");
    if (splinted.length > 1) {
      return (splinted[0].substring(0, 1) + splinted[1].substring(0, 1))
          .toUpperCase();
    } else {
      return name.substring(0, 2).toUpperCase();
    }
  }
}
