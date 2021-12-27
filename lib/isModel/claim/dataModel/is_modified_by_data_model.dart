import 'package:insurance/isModel/is_utils_string.dart';

class ISModifiedByDataModel {
  String id = "";
  String userId = "";
  String szUsername = "";
  String szName = "";
  String szPhoto = "";
  String szEmail = "";
  String szPhone = "";

  ISModifiedByDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    userId = "";
    szUsername = "";
    szName = "";
    szPhone = "";
    szEmail = "";
    szPhone = "";
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
    if (dictionary.containsKey("username")) {
      szUsername = ISUtilsString.refineString(dictionary["username"]);
    }
    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("email")) {
      szEmail = ISUtilsString.refineString(dictionary["email"]);
    }
    if (dictionary.containsKey("photo")) {
      szPhoto = ISUtilsString.refineString(dictionary["photo"]);
    }
    if (dictionary.containsKey("phone")) {
      szPhone = ISUtilsString.refineString(dictionary["phone"]);
    }
  }
}
