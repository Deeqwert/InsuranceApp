import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_field_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_section_data_model.dart';

class ISSubFormDataModel {
  String szFormName = "";
  List<ISFormSectionDataModel> arraySections = [];
  String szTitleFieldKey = "";
  bool allowMultipleInstances = false;
  Map<String, dynamic> dictCopy = {};

  ISSubFormDataModel() {
    initialize();
  }

  initialize() {
    szFormName = "";
    arraySections = [];
    szTitleFieldKey = "";
    allowMultipleInstances = false;
    dictCopy = {};
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("name")) {
        szFormName = ISUtilsString.refineString(dictionary["name"]);
      }
      if (dictionary.containsKey("sections") &&
          dictionary["sections"] != null) {
        final List<dynamic> sections = dictionary["sections"];
        for (int i in Iterable.generate(sections.length)) {
          final dict = sections[i];
          final section = ISFormSectionDataModel();
          section.deserialize(dict);
          if (section.isValid()) {
            arraySections.add(section);
          }
        }
      }
    } catch (error) {
      ISUtilsGeneral.log("response: " + error.toString());
    }
    dictCopy = dictionary;
  }

  Map<String, dynamic>? serialize() {
    final List<dynamic> array = [];
    for (var section in arraySections) {
      array.add(section.serialize());
    }
    final Map<String, dynamic> dic = {};
    try {
      dic["name"] = szFormName;
      dic["sections"] = array;
    } catch (error) {
      ISUtilsGeneral.log("response: " + error.toString());
    }
    return dic;
  }

  bool isValid() {
    return arraySections.isNotEmpty;
  }

  ISSubFormDataModel? cloneModel() {
    final ISSubFormDataModel newModel = ISSubFormDataModel();
    newModel.deserialize(dictCopy);
    newModel.szTitleFieldKey = szTitleFieldKey;
    newModel.allowMultipleInstances = allowMultipleInstances;
    return newModel;
  }

  String getFormTitle() {
    // If titleField is available, we return the value of that field

    final ISFormFieldDataModel? titleField = getFieldByKey(szTitleFieldKey);
    if (titleField != null &&
        titleField.parsedObject is String &&
        (titleField.parsedObject as String).isNotEmpty) {
      return titleField.parsedObject as String;
    }

    // if allowMultipleInstance allowed, return "New Form"
    return (allowMultipleInstances) ? "New Form *" : szFormName;
  }

  ISFormFieldDataModel? getFieldByKey(String fieldKey) {
    if (fieldKey.isEmpty) return null;
    for (var section in arraySections) {
      if (section.getFieldByKey(fieldKey) != null) {
        return section.getFieldByKey(fieldKey);
      }
    }
    return null;
  }

  setFormTitle(String title) {
    final ISFormFieldDataModel? titleField = getFieldByKey(szTitleFieldKey);
    if (titleField != null) {
      titleField.parsedObject = title;
    }
  }
}
