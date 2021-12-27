import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_configuration_data_model.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_definition_data_model.dart';

class ISFormSubmissionDataModel {
  String id = "";
  String organizationId = "";
  ISFormConfigurationDataModel modelFormData = ISFormConfigurationDataModel();

  ISFormSubmissionDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    organizationId = "";
    modelFormData = ISFormConfigurationDataModel();
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("id")) {
        id = ISUtilsString.refineString(dictionary["id"]);
      }
      if (dictionary.containsKey("organization") &&
          dictionary["organization"] != null) {
        final Map<String, dynamic> dic = dictionary["organization"];
        organizationId = ISUtilsString.refineString(dic["organizationId"]);
      }
      if (organizationId.isEmpty) {
        // For backward compatibility
        if (dictionary.containsKey("organizationId")) {
          organizationId =
              ISUtilsString.refineString(dictionary["organizationId"]);
        }
      }
      if (dictionary.containsKey("formData") &&
          dictionary["formData"] != null) {
        modelFormData.deserialize(dictionary["formData"]);
      }
    } catch (error) {
      ISUtilsGeneral.log("Form Submission deserialize - $error");
    }
  }

  Map<String, dynamic> serialize() {
    final Map<String, dynamic> ser = {};
    try {
      ser["formData"] = modelFormData.serialize();
    } catch (error) {
      ISUtilsGeneral.log("Form Submission Serialize - $error");
    }
    return ser;
  }

  Map<String, dynamic> serializeForOffline() {
    final Map<String, dynamic> ser = {};

    try {
      ser["id"] = id;
      Map<String, dynamic> org = {};
      org["organizationId"] = organizationId;
      ser["organization"] = org;
      ser["formData"] = modelFormData.serialize();
    } catch (error) {
      ISUtilsGeneral.log("Offline Form Submission Serialize - $error");
    }

    return ser;
  }

  ISFormSubmissionDataModel? instanceFromFormDefinition(
      ISFormDefinitionDataModel formDef) {
    final ISFormSubmissionDataModel submission = ISFormSubmissionDataModel();
    submission.organizationId = formDef.organizationId;
    submission.modelFormData.deserialize(formDef.modelConfiguration.payload);
    return submission;
  }
}
