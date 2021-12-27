import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/claim/dataModel/is_media_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_field_data_source_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_field_rule_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_field_rule_result_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_sub_form_data_model.dart';

class ISFormFieldDataModel {
  String szFieldName = "";
  String szFieldKey = "";
  dynamic anyFieldValue;

  List<ISFormFieldDataSourceDataModel> arrayDataSource = [];
  List<ISFormFieldRuleDataModel> arrayFieldRules = [];
  ISSubFormDataModel? modelSubFormTemplate = ISSubFormDataModel();

  ISEnumFormFieldType enumFieldType = ISEnumFormFieldType.unrecognized;
  ISEnumFormFieldValueType enumFieldValueType =
      ISEnumFormFieldValueType.unrecognized;
  ISEnumFormFieldAlertType enumAlertType =
      ISEnumFormFieldAlertType.unrecognized;

  bool allowMultipleInstances = false; // for sub-forms only
  String szTitleFieldKey = ""; // for sub-forms only

  bool isRequired = true;
  bool isIncludedInReport = true; // for photo-pickers

  dynamic parsedObject;
  bool isVisible = true;

  ISFormFieldDataModel() {
    initialize();
  }

  initialize() {
    szFieldName = "";
    szFieldKey = "";
    anyFieldValue = null;
    arrayDataSource = [];
    arrayFieldRules = [];
    modelSubFormTemplate = ISSubFormDataModel();

    enumFieldType = ISEnumFormFieldType.textField;
    enumFieldValueType = ISEnumFormFieldValueType.string;
    enumAlertType = ISEnumFormFieldAlertType.warning;

    allowMultipleInstances = false;
    szTitleFieldKey = "";

    isRequired = false;
    isIncludedInReport = true;

    parsedObject = null;
    isVisible = true;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("name")) {
        szFieldName = ISUtilsString.refineString(dictionary["name"]);
      }
      if (dictionary.containsKey("key")) {
        szFieldKey = ISUtilsString.refineString(dictionary["key"]);
      }
      if (dictionary.containsKey("value")) anyFieldValue = dictionary["value"];
      if (dictionary.containsKey("type")) {
        enumFieldType = FormFieldTypeExtension.fromString(
            ISUtilsString.refineString(dictionary["type"]));
      }
      // if (dictionary.containsKey("fieldValueType"))
      //   enumFieldValueType = FormFieldValueTypeExtension.fromString(
      //       ISUtilsString.refineString(dictionary["fieldValueType"]));
      // if (dictionary.containsKey("alertType"))
      //   enumAlertType = FormFieldAlertTypeExtension.fromString(
      //       ISUtilsString.refineString(dictionary["alertType"]));

      if (dictionary.containsKey("multipleInstances")) {
        allowMultipleInstances =
            ISUtilsString.refineBool(dictionary["multipleInstances"], false);
      }
      if (dictionary.containsKey("titleKey")) {
        szTitleFieldKey = ISUtilsString.refineString(dictionary["titleKey"]);
      }
      if (dictionary.containsKey("required")) {
        isRequired = ISUtilsString.refineBool(dictionary["required"], false);
      }
      if (dictionary.containsKey("includedInReport")) {
        isIncludedInReport =
            ISUtilsString.refineBool(dictionary["includedInReport"], true);
      }
      if (dictionary.containsKey("visible")) {
        isVisible = ISUtilsString.refineBool(dictionary["visible"], true);
      }
      if (dictionary.containsKey("dataSources") &&
          dictionary["dataSources"] != null) {
        final List<dynamic> dataSources = dictionary["dataSources"];
        for (int i in Iterable.generate(dataSources.length)) {
          final s = dataSources[i];
          final ds = ISFormFieldDataSourceDataModel();
          ds.deserializeFromString(s);
          if (ds.isValid()) {
            arrayDataSource.add(ds);
          }
        }
      } else if (dictionary.containsKey("dataSource") &&
          dictionary["dataSource"] != null) {
        final List<dynamic> dataSources = dictionary["dataSource"];
        for (int i in Iterable.generate(dataSources.length)) {
          final Map<String, dynamic> dict = dataSources[i];
          final ds = ISFormFieldDataSourceDataModel();
          ds.deserializeFromDictionary(dict);
          if (ds.isValid()) {
            arrayDataSource.add(ds);
          }
        }
      }
      if (dictionary.containsKey("rules") && dictionary["rules"] != null) {
        final List<dynamic> jsonFieldRules = dictionary["rules"];
        for (int i in Iterable.generate(jsonFieldRules.length)) {
          final dict = jsonFieldRules[i];
          final ds = ISFormFieldRuleDataModel();
          ds.deserialize(dict);
          if (ds.isValid()) {
            arrayFieldRules.add(ds);
          }
        }
      }
      if (enumFieldType == ISEnumFormFieldType.subForm) {
        if (dictionary.containsKey("subForm") &&
            dictionary["subForm"] != null) {
          final Map<String, dynamic> subForm = dictionary["subForm"];
          modelSubFormTemplate?.deserialize(subForm);
          modelSubFormTemplate?.szTitleFieldKey = szTitleFieldKey;
          modelSubFormTemplate?.allowMultipleInstances = allowMultipleInstances;
        }
        if (anyFieldValue is List<dynamic>) {
          final subForms = anyFieldValue as List<dynamic>?;
          final List<ISSubFormDataModel> array = [];
          for (int i in Iterable.generate(subForms!.length)) {
            final Map<String, dynamic> dict = subForms[i];
            final sb = ISSubFormDataModel();
            sb.deserialize(dict);
            sb.szTitleFieldKey = szTitleFieldKey;
            sb.allowMultipleInstances = allowMultipleInstances;
            array.add(sb);
          }
          parsedObject = array;
        }
      } else if (enumFieldType == ISEnumFormFieldType.multiPhotoPicker) {
        final List<ISMediaDataModel> array = [];
        if (anyFieldValue is List<dynamic>) {
          final media = anyFieldValue as List<dynamic>?;
          for (int i in Iterable.generate(media!.length)) {
            final Map<String, dynamic> jsonObject = media[i];
            final medium = ISMediaDataModel();
            medium.deserialize(jsonObject);
            if (medium.isValid()) array.add(medium);
          }
        }
        parsedObject = array;
      } else if (enumFieldType == ISEnumFormFieldType.singlePhotoPicker ||
          enumFieldType == ISEnumFormFieldType.signature) {
        if (anyFieldValue is Map<String, dynamic>) {
          final jsonMedium = anyFieldValue as Map<String, dynamic>;
          final medium = ISMediaDataModel();
          medium.deserialize(jsonMedium);
          if (medium.isValid()) parsedObject = medium;
        }
      } else if (enumFieldType == ISEnumFormFieldType.multiListPicker) {
        if (anyFieldValue is List<dynamic>) {
          final anyValues = anyFieldValue as List<dynamic>;
          final List<String> array = [];
          for (int i in Iterable.generate(anyValues.length)) {
            final strValue = anyValues[i];
            array.add(strValue);
          }
          parsedObject = array;
        } else {
          parsedObject = [];
        }
      } else {
        parsedObject = anyFieldValue;
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }

  Map<String, dynamic>? serialize() {
    final Map<String, dynamic> jsonObject = {};
    try {
      jsonObject["name"] = szFieldName;
      jsonObject["key"] = szFieldKey;
      jsonObject["type"] = enumFieldType.value;
      // jsonObject["fieldValueType"] = enumFieldValueType.value;
      // jsonObject["alertType"] = enumAlertType.value;
      jsonObject["includedInReport"] = isIncludedInReport;
      jsonObject["required"] = isRequired;
      jsonObject["visible"] = isVisible;
      if (enumFieldType == ISEnumFormFieldType.subForm &&
          modelSubFormTemplate != null) {
        jsonObject["subForm"] = modelSubFormTemplate!.serialize();
        jsonObject["multipleInstances"] = allowMultipleInstances;
        jsonObject["titleKey"] = szTitleFieldKey;
      }
      if (parsedObject != null && hasValue()) {
        // Build anyFieldValue
        if (enumFieldType == ISEnumFormFieldType.multiPhotoPicker) {
          // [ISISMediaDataModel]
          final List<ISMediaDataModel>? media =
              parsedObject as List<ISMediaDataModel>?;
          if (media != null) {
            final List<dynamic> newValue = [];
            for (int i in Iterable.generate(media.length)) {
              final ISMediaDataModel medium = media[i];
              final Map<String, dynamic> dict = medium.serializeForCreate();
              dict["id"] = medium.id;
              newValue.add(dict);
            }
            anyFieldValue = newValue;
          }
        } else if (enumFieldType == ISEnumFormFieldType.singlePhotoPicker) {
          final ISMediaDataModel? medium = parsedObject as ISMediaDataModel?;
          if (medium != null) {
            final Map<String, dynamic> dict = medium.serializeForCreate();
            dict["id"] = medium.id;
            anyFieldValue = dict;
          }
        } else if (enumFieldType == ISEnumFormFieldType.signature) {
          final ISMediaDataModel? medium = parsedObject as ISMediaDataModel?;
          if (medium != null) {
            final Map<String, dynamic> dict = medium.serializeForCreate();
            dict["id"] = medium.id;
            anyFieldValue = dict;
          }
        } else if (enumFieldType == ISEnumFormFieldType.subForm) {
          final List<ISSubFormDataModel>? subForms =
              parsedObject as List<ISSubFormDataModel>?;
          // [ISISMediaDataModel]
          if (subForms != null) {
            final List<dynamic> newValue = [];
            for (int i in Iterable.generate(subForms.length)) {
              final ISSubFormDataModel sb = subForms[i];
              final Map<String, dynamic>? dict = sb.serialize();
              newValue.add(dict);
            }
            anyFieldValue = newValue;
          }
        } else if (enumFieldType == ISEnumFormFieldType.multiListPicker) {
          // Do not delete. It should be different with iOS version. issued by 2020-02-25 ex : {"value" : "[siding, brick]"}
          if (parsedObject != null) {
            final arrayObjects = parsedObject as List<String>?;
            final List<dynamic> array = [];
            for (var str in arrayObjects!) {
              array.add(str);
            }
            anyFieldValue = array;
          } else {
            anyFieldValue = [];
          }
        } else {
          anyFieldValue = parsedObject;
        }
        jsonObject["value"] = anyFieldValue;
      }
      final List<dynamic> arrDataSource = [];
      for (var ds in arrayDataSource) {
        arrDataSource.add(ds.serializeToString());
      }
      jsonObject["dataSources"] = arrDataSource;
      final List<dynamic> arrFieldRules = [];
      for (var rule in arrayFieldRules) {
        arrFieldRules.add(rule.serialize());
      }
      jsonObject["rules"] = arrFieldRules;
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
    return jsonObject;
  }

  bool isValid() {
    return enumFieldType != ISEnumFormFieldType.unrecognized;
  }

  bool hasValue() {
    if (enumFieldType == ISEnumFormFieldType.multiPhotoPicker) {
      final List<ISMediaDataModel>? values =
          parsedObject as List<ISMediaDataModel>?;
      return (values != null && values.isNotEmpty) ? true : false;
    } else if (enumFieldType == ISEnumFormFieldType.singlePhotoPicker ||
        enumFieldType == ISEnumFormFieldType.signature) {
      final ISMediaDataModel? value = parsedObject as ISMediaDataModel?;
      return value != null;
    } else if (enumFieldType == ISEnumFormFieldType.multiListPicker) {
      final values = parsedObject as List<String>?;
      return values != null && values.isNotEmpty;
    } else if (enumFieldType == ISEnumFormFieldType.subForm) {
      final List<ISSubFormDataModel>? values =
          parsedObject as List<ISSubFormDataModel>?;
      return values != null && values.isNotEmpty;
    } else {
      if (parsedObject is String) {
        final stringValue = parsedObject as String?;
        if (stringValue!.isNotEmpty) return true;
      } else if (parsedObject != null) {
        return true;
      }
    }
    return false;
  }

  String? convertObjectToString(dynamic anyValue) {
    if (anyValue == null) return "";
    final str = anyValue.toString();
    return (str.isEmpty || str == "null") ? "" : str;
  }

  List<ISFormFieldRuleResultDataModel>? generateFieldRulesResult() {
    final List<ISFormFieldRuleResultDataModel> array = [];
    if (enumFieldType == ISEnumFormFieldType.subForm) {
      if (modelSubFormTemplate != null) {
        for (var section in modelSubFormTemplate!.arraySections) {
          for (var field in section.arrayFields) {
            array.addAll(field.generateFieldRulesResult()!);
          }
        }
      }
    } else {
      for (var rule in arrayFieldRules) {
        final bool visible = (rule.testValue(parsedObject))
            ?
            // Apply "action"
            rule.enumAction == ISEnumFormFieldRuleAction.show
            :
            // Apply "elseAction"
            rule.enumElseAction == ISEnumFormFieldRuleAction.show;

        for (var key in rule.arrayTargetKeys) {
          final result = ISFormFieldRuleResultDataModel();
          result.szFieldKey = key;
          result.isVisible = visible;
          array.add(result);
        }
      }
    }
    return array;
  }

  ISSubFormDataModel? addNewInstanceForSubForm(String? title) {
    if (parsedObject != null) {
      final List<ISSubFormDataModel>? parsedObj =
          parsedObject as List<ISSubFormDataModel>?;

      // Create new
      final ISSubFormDataModel? newSubForm = modelSubFormTemplate?.cloneModel();
      // set form-title
      newSubForm?.setFormTitle(title!);
      final List<ISSubFormDataModel> newParsedObject =
          List.from(parsedObj!.toList());
      newParsedObject.add(newSubForm!);
      parsedObject = newParsedObject;
    } else {
      final ISSubFormDataModel? newSubForm = modelSubFormTemplate?.cloneModel();

      // set form-title
      newSubForm?.setFormTitle(title!);
      final List<ISSubFormDataModel> newParsedObject = [];
      newParsedObject.add(newSubForm!);
      parsedObject = newParsedObject;
    }
    return null;
  }

  deleteSubFormAtIndex(int index) {
    if (parsedObject != null) {
      final List<ISSubFormDataModel>? parsedObj =
          parsedObject as List<ISSubFormDataModel>?;
      if (index < parsedObj!.length) {
        parsedObj.removeAt(index);
        parsedObject = parsedObj;
      }
    }
  }

  ISSubFormDataModel? getISSubFormDataModelAtIndex(int index) {
    // Create if needed
    if (parsedObject != null) {
      final List<ISSubFormDataModel>? parsedObj =
          parsedObject as List<ISSubFormDataModel>?;
      if (parsedObj!.length == index) {
        addNewInstanceForSubForm("");
      } else if (parsedObj.length > index) {
        return parsedObj[index];
      } else {
        return null;
      }
    } else {
      addNewInstanceForSubForm("");
    }
// Following code will never be executed
// return nil
  }
}

enum ISEnumFormFieldType {
  textField,
  numberField,
  textView,
  formattedField,
  datePicker,
  singleListPicker,
  multiListPicker,
  multiPhotoPicker,
  singlePhotoPicker,
  textLabel,
  signature,
  subForm,
  unrecognized
}

extension FormFieldTypeExtension on ISEnumFormFieldType {
  static ISEnumFormFieldType fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumFormFieldType.unrecognized;
    }
    for (var t in ISEnumFormFieldType.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumFormFieldType.unrecognized;
  }

  String get value {
    switch (this) {
      case ISEnumFormFieldType.textField:
        return "SingleLineEntryAlpha";
      case ISEnumFormFieldType.numberField:
        return "SingleLineEntryNumeric";
      case ISEnumFormFieldType.textView:
        return "MultiLineEntry";
      case ISEnumFormFieldType.formattedField:
        return "FormattedInput";
      case ISEnumFormFieldType.datePicker:
        return "DatePicker";
      case ISEnumFormFieldType.singleListPicker:
        return "ListPicker";
      case ISEnumFormFieldType.multiListPicker:
        return "MultiListPicker";
      case ISEnumFormFieldType.multiPhotoPicker:
        return "MultiPhotoPicker";
      case ISEnumFormFieldType.singlePhotoPicker:
        return "PhotoPicker";
      case ISEnumFormFieldType.textLabel:
        return "TextLabel";
      case ISEnumFormFieldType.signature:
        return "SignatureCapture";
      case ISEnumFormFieldType.subForm:
        return "SubFormPicker";
      case ISEnumFormFieldType.unrecognized:
        return "";
    }
  }
}

enum ISEnumFormFieldValueType {
  string,
  integer,
  dateOnly,
  array,
  unComparable,
  unrecognized
}

extension FormFieldValueTypeExtension on ISEnumFormFieldValueType {
  static ISEnumFormFieldValueType fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumFormFieldValueType.unrecognized;
    }
    for (var t in ISEnumFormFieldValueType.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumFormFieldValueType.unrecognized;
  }

  String get value {
    switch (this) {
      case ISEnumFormFieldValueType.string:
        return "String";
      case ISEnumFormFieldValueType.integer:
        return "Integer";
      case ISEnumFormFieldValueType.dateOnly:
        return "DateOnly";
      case ISEnumFormFieldValueType.array:
        return "Array";
      case ISEnumFormFieldValueType.unComparable:
        return "Uncomparable";
      case ISEnumFormFieldValueType.unrecognized:
        return "";
    }
  }
}

enum ISEnumFormFieldAlertType { warning, unrecognized }

extension FormFieldAlertTypeExtension on ISEnumFormFieldAlertType {
  static ISEnumFormFieldAlertType fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumFormFieldAlertType.unrecognized;
    }
    for (var t in ISEnumFormFieldAlertType.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumFormFieldAlertType.unrecognized;
  }

  String get value {
    switch (this) {
      case ISEnumFormFieldAlertType.warning:
        return "WARNING";
      case ISEnumFormFieldAlertType.unrecognized:
        return "";
    }
  }
}
