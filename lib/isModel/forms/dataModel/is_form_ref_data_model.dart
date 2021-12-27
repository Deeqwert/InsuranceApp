import 'package:insurance/isModel/is_utils_string.dart';

class ISFormRefDataModel {
  String formId = "";
  String szName = "";

  initialize() {
    formId = "";
    szName = "";
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("formId")) {
      formId = ISUtilsString.refineString(dictionary["formId"]);
    }
    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
  }

  Map<String, dynamic> serialize() {
    final Map<String, dynamic> jsonObject = {};
    jsonObject["formId"] = formId;
    jsonObject["name"] = szName;
    return jsonObject;
  }

  bool isValid() => formId.isNotEmpty;
}
