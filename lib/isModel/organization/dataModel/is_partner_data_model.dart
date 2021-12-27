import 'package:insurance/isModel/is_utils_string.dart';

class ISPartnerDataModel {
  String organizationId = "";
  String szName = "";
  String szType = "";
  ISEnumPartnerStatus enumStatus = ISEnumPartnerStatus.active;

  ISPartnerDataModel() {
    initialize();
  }

  initialize() {
    organizationId = "";
    szName = "";
    szType = "";
    enumStatus = ISEnumPartnerStatus.active;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;

    if (dictionary.containsKey("organizationId")) {
      organizationId = ISUtilsString.refineString(dictionary["organizationId"]);
    }
    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("type")) {
      szType = ISUtilsString.refineString(dictionary["type"]);
    }
    if (dictionary.containsKey("status")) {
      enumStatus = ISEnumPartnerStatusExtension.fromString(
          ISUtilsString.refineString(dictionary["status"]));
    }
  }

  bool isValid() {
    return organizationId.isNotEmpty &&
        enumStatus != ISEnumPartnerStatus.deleted;
  }
}

enum ISEnumPartnerStatus {
  active,
  deleted,
}

extension ISEnumPartnerStatusExtension on ISEnumPartnerStatus {
  String get value {
    switch (this) {
      case ISEnumPartnerStatus.active:
        return "Active";
      case ISEnumPartnerStatus.deleted:
        return "Deleted";
    }
  }

  static ISEnumPartnerStatus fromString(String? string) {
    if (string == null || string.isEmpty) return ISEnumPartnerStatus.active;
    if (string.toLowerCase() ==
        ISEnumPartnerStatus.active.value.toLowerCase()) {
      return ISEnumPartnerStatus.active;
    } else if (string.toLowerCase() ==
        ISEnumPartnerStatus.deleted.value.toLowerCase()) {
      return ISEnumPartnerStatus.deleted;
    }
    return ISEnumPartnerStatus.active;
  }
}
