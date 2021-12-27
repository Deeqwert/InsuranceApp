import 'package:insurance/isModel/is_utils_string.dart';

class ISFormFieldDataSourceDataModel {
  String szName = "";
  String szValue = "";

  ISFormFieldDataSourceDataModel() {
    initialize();
  }

  initialize() {
    szName = "";
    szValue = "";
  }

  deserializeFromString(dynamic value) {
    initialize();

    if (value == null) return;

    if (value is String) {
      szName = value;
      szValue = value;
    }
  }

  deserializeFromDictionary(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("value")) {
      szValue = ISUtilsString.refineString(dictionary["value"]);
    }
  }

  String serializeToString() => szValue;

  Map<String, dynamic> serializeToDictionary() {
    final Map<String, dynamic> jsonObject = {};
    jsonObject["name"] = szName;
    jsonObject["value"] = szValue;
    return jsonObject;
  }

  bool isValid() => !(szName.isEmpty && szValue.isEmpty);
}
