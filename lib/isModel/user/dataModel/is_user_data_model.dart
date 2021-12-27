import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISUserDataModel {
  String id = "";
  String userId = "";
  String szName = "";
  String szUserName = "";
  String szEmail = "";
  String szPassword = "";
  String szPhone = "";
  String szDeviceToken = "";
  ISEnumUserStatus enumStatus = ISEnumUserStatus.active;

  ISUserDataModel() {
    initialize();
  }

  initialize() {
    this.id = "";
    this.userId = "";
    this.szUserName = "";
    this.szName = "";
    this.szEmail = "";
    this.szPassword = "";
    this.szPhone = "";
    this.szDeviceToken = "";
    this.enumStatus = ISEnumUserStatus.active;
  }

  Map<String, dynamic>? serializeForLocalStorage() {
    final Map<String, dynamic> dict = {};
    dict["id"] = id;
    dict["userId"] = userId;
    dict["username"] = szUserName;
    dict["name"] = szName;
    dict["email"] = szEmail;
    dict["password"] = szPassword;
    dict["phone"] = szPhone;
    dict["deviceToken"] = szDeviceToken;
    dict["status"] = enumStatus.value;
    return dict;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;
    try {
      if (dictionary.containsKey("id")) {
        id = ISUtilsString.refineString(dictionary["id"]);
      }
      if (dictionary.containsKey("userId")) {
        userId = ISUtilsString.refineString(dictionary["userId"]);
      }
      if (dictionary.containsKey("username")) {
        szUserName = ISUtilsString.refineString(dictionary["username"]);
      }
      if (dictionary.containsKey("name")) {
        szName = ISUtilsString.refineString(dictionary["name"]);
      }
      if (dictionary.containsKey("email")) {
        szEmail = ISUtilsString.refineString(dictionary["email"]);
      }
      if (dictionary.containsKey("password")) {
        szPassword = ISUtilsString.refineString(dictionary["password"]);
      }
      if (dictionary.containsKey("status")) {
        enumStatus = UserStatusExtension.fromString(
            ISUtilsString.refineString(dictionary["status"]));
      }
      if (dictionary.containsKey("phone")) {
        szPhone = ISUtilsString.refineString(dictionary["phone"]);
      }
      if (dictionary.containsKey("deviceToken")) {
        szDeviceToken = ISUtilsString.refineString(dictionary["deviceToken"]);
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }

  String getInitials() {
    if (szName.isEmpty) return "";
    return ISUtilsString.getInitialsFromName(szName);
  }

  bool isValid() {
    return (id.isNotEmpty && enumStatus == ISEnumUserStatus.active);
  }
}

enum ISEnumUserStatus { active, delete }

extension UserStatusExtension on ISEnumUserStatus {
  static ISEnumUserStatus fromString(String? str) {
    if (str == null || str.isEmpty) {
      return ISEnumUserStatus.active;
    }
    if (str.toLowerCase() == ISEnumUserStatus.active.toString().toLowerCase()) {
      return ISEnumUserStatus.active;
    } else if (str.toLowerCase() ==
        ISEnumUserStatus.delete.toString().toLowerCase()) {
      return ISEnumUserStatus.delete;
    }
    return ISEnumUserStatus.active;
  }

  String get value {
    switch (this) {
      case ISEnumUserStatus.active:
        return "Active";
      case ISEnumUserStatus.delete:
        return "Deleted";
    }
  }
}
