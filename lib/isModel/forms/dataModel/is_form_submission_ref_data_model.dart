import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISFormSubmissionRefDataModel {
  String submissionId = "";
  String formId = "";
  String szFormName = "";

  ISFormSubmissionRefDataModel() {
    initialize();
  }

  initialize() {
    submissionId = "";
    formId = "";
    szFormName = "";
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("submissionId")) {
        submissionId = ISUtilsString.refineString(dictionary["submissionId"]);
      }
      if (dictionary.containsKey("formId")) {
        formId = ISUtilsString.refineString(dictionary["formId"]);
      }
      if (dictionary.containsKey("formName")) {
        szFormName = ISUtilsString.refineString(dictionary["formName"]);
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }

  Map<String, dynamic> serialize() {
    final Map<String, dynamic> json = {};
    try {
      json["submissionId"] = submissionId;
      json["formId"] = formId;
      json["formName"] = szFormName;
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
    return json;
  }

  bool isValid() {
    return submissionId.isNotEmpty;
  }
}
