import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/forms/dataModel/is_form_configuration_data_model.dart';

class ISFormDefinitionDataModel {
  String id = "";
  String organizationId = "";
  String szName = "";
  ISFormConfigurationDataModel modelConfiguration =
      ISFormConfigurationDataModel();

  ISEnumFormDefinitionStatus enumStatus = ISEnumFormDefinitionStatus.active;
  DateTime? dateCreatedAt;
  DateTime? dateUpdatedAt;
  Map<String, dynamic> payload = {};

  ISFormDefinitionDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    organizationId = "";
    szName = "";
    modelConfiguration = ISFormConfigurationDataModel();
    dateCreatedAt = null;
    dateUpdatedAt = null;
    enumStatus = ISEnumFormDefinitionStatus.active;
    payload = {};
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    try {
      if (dictionary.containsKey("id")) {
        id = ISUtilsString.refineString(dictionary["id"]);
      }
      if (dictionary.containsKey("organizationId")) {
        organizationId =
            ISUtilsString.refineString(dictionary["organizationId"]);
      }
      if (dictionary.containsKey("name")) {
        szName = ISUtilsString.refineString(dictionary["name"]);
      }
      if (dictionary.containsKey("form") && dictionary["form"] != null) {
        final Map<String, dynamic> config = dictionary["form"];
        modelConfiguration.deserialize(config);
      } else if (dictionary.containsKey("formConfiguration") &&
          dictionary["formConfiguration"] != null) {
        final Map<String, dynamic> config = dictionary["formConfiguration"];
        modelConfiguration.deserialize(config);
      }
      if (dictionary.containsKey("createdAt")) {
        dateCreatedAt = ISUtilsDate.getDateTimeFromStringWithFormat(
            ISUtilsString.refineString(dictionary["createdAt"]),
            ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
            true);
      }
      if (dictionary.containsKey("updatedAt")) {
        dateUpdatedAt = ISUtilsDate.getDateTimeFromStringWithFormat(
            ISUtilsString.refineString(dictionary["updatedAt"]),
            ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
            true);
      }
      if (dictionary.containsKey("status")) {
        enumStatus = FormDefinitionStatusExtension.fromString(
            ISUtilsString.refineString(dictionary["status"]));
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
    payload = dictionary;
  }

  Map<String, dynamic>? serializeForOffline() {
    return payload;
  }

  bool isValid() {
    return id.isNotEmpty && modelConfiguration.isValid();
  }
}

enum ISEnumFormDefinitionStatus { active, deactive }

extension FormDefinitionStatusExtension on ISEnumFormDefinitionStatus {
  static ISEnumFormDefinitionStatus fromString(String? status) {
    if (status == null || status.isEmpty) {
      return ISEnumFormDefinitionStatus.active;
    }
    for (var t in ISEnumFormDefinitionStatus.values) {
      if (status.toLowerCase() == t.value.toLowerCase()) return t;
    }
    return ISEnumFormDefinitionStatus.active;
  }

  String get value {
    switch (this) {
      case ISEnumFormDefinitionStatus.active:
        return "Active";
      case ISEnumFormDefinitionStatus.deactive:
        return "Deactive";
    }
  }
}
