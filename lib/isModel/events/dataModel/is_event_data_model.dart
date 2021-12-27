import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISEventDataModel {
  String id = "";
  String organizationId = "";
  String szName = "";
  DateTime? dateEffective;
  DateTime? dateExpiration;
  ISEnumEventStatus enumStatus = ISEnumEventStatus.active;

  ISEventDataModel() {
    initialize();
  }
  initialize() {
    id = "";
    organizationId = "";
    szName = "";
    dateEffective = null;
    dateExpiration = null;
    enumStatus = ISEnumEventStatus.active;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;
    if (dictionary.containsKey("id")) {
      id = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("organizationId")) {
      organizationId = ISUtilsString.refineString(dictionary["organizationId"]);
    }
    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("effectiveDate")) {
      dateEffective = ISUtilsDate.getDateTimeFromStringWithFormat(
          dictionary["effectiveDate"],
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.toString(),
          true);
    }
    if (dictionary.containsKey("expirationDate")) {
      dateEffective = ISUtilsDate.getDateTimeFromStringWithFormat(
          dictionary["expirationDate"],
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.toString(),
          true);
    }
    if (dictionary.containsKey("status")) {
      enumStatus = ISEnumEventStatusExtension.fromString(
          ISUtilsString.refineString(dictionary["status"]));
    }
  }

   bool isValid() {
    return id.isNotEmpty;
  }
}

enum ISEnumEventStatus { active, deleted }

extension ISEnumEventStatusExtension on ISEnumEventStatus {
  String get value {
    switch (this) {
      case ISEnumEventStatus.active:
        return "Active";
      case ISEnumEventStatus.deleted:
        return "Deleted";
    }
  }

  static ISEnumEventStatus fromString(String? string) {
    if (string == null || string.isEmpty) return ISEnumEventStatus.active;
    if (string.toLowerCase() ==
        ISEnumEventStatus.active.toString().toLowerCase()) {
      return ISEnumEventStatus.active;
    } else if (string.toLowerCase() ==
        ISEnumEventStatus.deleted.toString().toLowerCase()) {
      return ISEnumEventStatus.deleted;
    }
    return ISEnumEventStatus.active;
  }
}
