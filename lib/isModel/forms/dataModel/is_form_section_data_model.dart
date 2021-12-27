import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_field_data_model.dart';

class ISFormSectionDataModel {
  List<ISFormFieldDataModel> arrayFields = [];
  String szHeader = "";
  String szLabel = "";
  String szKey = "";

  ISFormSectionDataModel() {
    initialize();
  }

  initialize() {
    szHeader = "";
    szLabel = "";
    szKey = "";
    arrayFields = [];
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("header")) {
        szHeader = ISUtilsString.refineString(dictionary["header"]);
      }
      if (dictionary.containsKey("label")) {
        szLabel = ISUtilsString.refineString(dictionary["label"]);
      }
      if (dictionary.containsKey("key")) {
        szKey = ISUtilsString.refineString(dictionary["key"]);
      }
      if (dictionary.containsKey("fields") && dictionary["fields"] != null) {
        final List<dynamic> fields = dictionary["fields"];
        for (int i in Iterable.generate(fields.length)) {
          final Map<String, dynamic> dict = fields[i];
          final field = ISFormFieldDataModel();
          field.deserialize(dict);
          if (field.isValid()) {
            arrayFields.add(field);
          }
        }
      }
    } catch (error) {
      ISUtilsGeneral.log("response: " + error.toString());
    }
  }

  Map<String, dynamic>? serialize() {
    final Map<String, dynamic> jsonObject = {};
    final List<dynamic> array = [];
    for (var field in arrayFields) {
      array.add(field.serialize());
    }
    try {
      jsonObject["header"] = szHeader;
      jsonObject["label"] = szLabel;
      jsonObject["key"] = szKey;
      jsonObject["fields"] = array;
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
    return jsonObject;
  }

  bool isValid() {
    return true; //(arrayFields.length > 0);
  }

  ISFormFieldDataModel? getFieldByKey(String? fieldKey) {
    for (var field in arrayFields) {
      if (field.szFieldKey == fieldKey) {
        return field;
      }
    }
    return null;
  }
}
