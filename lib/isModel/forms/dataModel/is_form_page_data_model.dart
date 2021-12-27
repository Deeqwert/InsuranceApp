import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_section_data_model.dart';

class ISFormPageDataModel {

  List<ISFormSectionDataModel> arraySections = [];
  String szKey = "";
  String szName = "";

  ISFormPageDataModel() {
    initialize();
  }

  initialize() {
    arraySections = [];
    szKey = "";
    szName = "";
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("key")) {
        szKey = ISUtilsString.refineString(dictionary["key"]);
      }
      if (dictionary.containsKey("name")) {
        szName = ISUtilsString.refineString(dictionary["name"]);
      }

      if (dictionary.containsKey("sections") &&
          dictionary["sections"] != null) {
        final List<dynamic> sections = dictionary["sections"];
        for (int i in Iterable.generate(sections.length)) {
          var dict = sections[i];
          var section = ISFormSectionDataModel();
          section.deserialize(dict);
          if (section.isValid()) arraySections.add(section);
        }
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }

  Map<String, dynamic>? serialize() {
    final Map<String, dynamic> jsonObject = {};
    final List<dynamic> array = [];
    for (var section in arraySections) {
      array.add(section.serialize());
    }
    try {
      jsonObject["key"] = szKey;
      jsonObject["name"] = szName;
      jsonObject["sections"] = array;
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
    return jsonObject;
  }

  bool isValid() => arraySections.isNotEmpty;
}