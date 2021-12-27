import 'package:insurance/isModel/is_utils_string.dart';

class ISAgentDataModel {
  String userId = "";
  String szName = "";
  String szPhone = "";
  String szEmail = "";

  ISAgentDataModel() {
    initialize();
  }

  initialize() {
    userId = "";
    szName = "";
    szPhone = "";
    szEmail = "";
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("userId")) {
      userId = ISUtilsString.refineString(dictionary["userId"]);
    }
    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("phone")) {
      szPhone = ISUtilsString.refineString(dictionary["phone"]);
    }
    if (dictionary.containsKey("email")) {
      szEmail = ISUtilsString.refineString(dictionary["email"]);
    }
  }

  isValid() {
    return !(userId.isEmpty &&
        szName.isEmpty &&
        szPhone.isEmpty &&
        szEmail.isEmpty);
  }
}
