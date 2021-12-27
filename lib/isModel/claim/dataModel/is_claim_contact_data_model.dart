import 'package:insurance/isModel/is_utils_string.dart';

class ISClaimContactDataModel {

  String szName = "";
  String szRelation = "";
  String szPhone = "";
  String szEmail = "";
  bool isPrimary = true;

  ISClaimContactDataModel() {
    initialize();
  }

  initialize() {
    szName = "";
    szRelation = "";
    szPhone = "";
    szEmail = "";
    isPrimary = true;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("relation")) {
      szRelation = ISUtilsString.refineString(dictionary["relation"]);
    }
    if (dictionary.containsKey("phone")) {
      szPhone = ISUtilsString.refineString(dictionary["phone"]);
    }
    if (dictionary.containsKey("email")) {
      szEmail = ISUtilsString.refineString(dictionary["email"]);
    }
    if (dictionary.containsKey("primary")) {
      isPrimary = ISUtilsString.refineBool(dictionary["primary"], true);
    }
  }
}
