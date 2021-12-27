import 'package:insurance/isModel/claim/dataModel/is_claim_data_model.dart';
import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISInviteDataModel {
  String id="";
  String organizationId="";
  String organizationName="";
  String token="";
  String szToEmail="";
  ISEnumOrganizationUserRole enumRole=ISEnumOrganizationUserRole.adjuster;
  ISEnumInvitationStatus enumStatus=ISEnumInvitationStatus.accepted;
  DateTime? dateCreatedAt;
  DateTime? dateUpdatedAt;

  ISInviteDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    organizationId = "";
    organizationName = "";
    token = "";
    szToEmail = "";
    enumRole = ISEnumOrganizationUserRole.adjuster;
    enumStatus = ISEnumInvitationStatus.accepted;
    dateCreatedAt = null;
    dateUpdatedAt = null;
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
    if (dictionary.containsKey("organizationName")) {
      organizationName = ISUtilsString.refineString(dictionary["organizationName"]);
    }
    if (dictionary.containsKey("token")) {
      token = ISUtilsString.refineString(dictionary["token"]);
    }
    if (dictionary.containsKey("createdAt")) {
      dateCreatedAt = ISUtilsDate.getDateTimeFromStringWithFormat(
          dictionary["createdAt"],
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }
    if (dictionary.containsKey("updatedAt")) {
      dateUpdatedAt = ISUtilsDate.getDateTimeFromStringWithFormat(
          dictionary["updatedAt"],
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }
    if (dictionary.containsKey("role")) {
      enumRole = ISEnumOrganizationExtension.fromString(ISUtilsString.refineString(dictionary["role"]));
    }
    if (dictionary.containsKey("status")) {
      enumStatus = ISEnumInvitationExtension.fromString(ISUtilsString.refineString(dictionary["status"]));
    }

  }
  bool isValid() {
    return token.isNotEmpty && id.isNotEmpty;
  }
}

enum ISEnumOrganizationUserRole {
  admin,
  adjusterAdmin,
  adjuster,
  agent,
  claimManager
}

extension ISEnumOrganizationExtension on ISEnumOrganizationUserRole {
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

enum ISEnumInvitationStatus { pending, accepted, declined }

extension ISEnumInvitationExtension on ISEnumInvitationStatus {
  static ISEnumInvitationStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumInvitationStatus.pending;
    }
    if (str.toLowerCase() ==
        ISEnumInvitationStatus.pending.value.toLowerCase()) {
      return ISEnumInvitationStatus.pending;
    } else if (str.toLowerCase() ==
        ISEnumInvitationStatus.accepted.value.toLowerCase()) {
      return ISEnumInvitationStatus.accepted;
    } else if (str.toLowerCase() ==
        ISEnumInvitationStatus.declined.value.toLowerCase()) {
      return ISEnumInvitationStatus.declined;
    }
    return ISEnumInvitationStatus.pending;
  }

  String get value {
    switch (this) {
      case ISEnumInvitationStatus.pending:
        return "Pending";
      case ISEnumInvitationStatus.accepted:
        return "Accepted";
      case ISEnumInvitationStatus.declined:
        return "Declined";
    }
  }
}

