import 'package:insurance/isModel/is_utils_string.dart';

class ISOrganizationUserDataModel {
  String id = "";
  String userId = "";
  String inviteId = "";
  ISEnumOrganizationUserRole enumRole = ISEnumOrganizationUserRole.adjuster;
  ISEnumOrganizationuserStatus enumStatus = ISEnumOrganizationuserStatus.active;

  ISOrganizationUserDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    userId = "";
    inviteId = "";
    enumRole = ISEnumOrganizationUserRole.adjuster;
    enumStatus = ISEnumOrganizationuserStatus.active;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;

    if (dictionary.containsKey("id")) {
      id = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("userId")) {
      userId = ISUtilsString.refineString(dictionary["userId"]);
    }
    if (dictionary.containsKey("inviteId")) {
      inviteId = ISUtilsString.refineString(dictionary["inviteId"]);
    }
    if (dictionary.containsKey("role")) {
      enumRole = ISEnumOrganizationUserRoleExtension.fromString(
          ISUtilsString.refineString(dictionary["role"]));
    }
    if (dictionary.containsKey("status")) {
      enumStatus = ISEnumOrganizationuserStatusExtension.fromString(
          ISUtilsString.refineString(dictionary["status"]));
    }
  }

  bool isValid() {
    return id.isNotEmpty &&
        userId.isNotEmpty &&
        enumStatus != ISEnumOrganizationuserStatus.deleted;
  }
}

enum ISEnumOrganizationUserRole {
  admin,
  adjusterAdmin,
  adjuster,
  agent,
  claimManager
}

extension ISEnumOrganizationUserRoleExtension on ISEnumOrganizationUserRole {
  static ISEnumOrganizationUserRole fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumOrganizationUserRole.adjuster;
    }
    if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.admin.value.toLowerCase()) {
      return ISEnumOrganizationUserRole.admin;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.adjusterAdmin.value.toLowerCase()) {
      return ISEnumOrganizationUserRole.adjusterAdmin;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.adjuster.value.toLowerCase()) {
      return ISEnumOrganizationUserRole.adjuster;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.agent.value.toLowerCase()) {
      return ISEnumOrganizationUserRole.agent;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationUserRole.claimManager.value.toLowerCase()) {
      return ISEnumOrganizationUserRole.claimManager;
    }
    return ISEnumOrganizationUserRole.adjuster;
  }

  String get value {
    switch (this) {
      case ISEnumOrganizationUserRole.admin:
        return "Administrator";
      case ISEnumOrganizationUserRole.adjusterAdmin:
        return "Adjuster Administrator";
      case ISEnumOrganizationUserRole.adjuster:
        return "Adjuster";
      case ISEnumOrganizationUserRole.agent:
        return "Agent";
      case ISEnumOrganizationUserRole.claimManager:
        return "Claim Manager";
    }
  }
}

enum ISEnumOrganizationuserStatus { active, deleted }

extension ISEnumOrganizationuserStatusExtension
    on ISEnumOrganizationuserStatus {
  static ISEnumOrganizationuserStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumOrganizationuserStatus.active;
    }
    if (str.toLowerCase() ==
        ISEnumOrganizationuserStatus.active.value.toLowerCase()) {
      return ISEnumOrganizationuserStatus.active;
    } else if (str.toLowerCase() ==
        ISEnumOrganizationuserStatus.deleted.value.toLowerCase()) {
      return ISEnumOrganizationuserStatus.deleted;
    }

    return ISEnumOrganizationuserStatus.active;
  }

  String get value {
    switch (this) {
      case ISEnumOrganizationuserStatus.active:
        return "Active";
      case ISEnumOrganizationuserStatus.deleted:
        return "Deleted";
    }
  }
}
