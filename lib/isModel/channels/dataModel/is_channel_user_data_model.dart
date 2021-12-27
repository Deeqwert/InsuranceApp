import 'package:insurance/isModel/is_utils_general.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISChannelUserDataModel {

  String id = "";
  String userId = "";
  String szName = "";
  String szUserName = "";
  String szEmail = '';

  ISChannelUserDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    userId = "";
    szName = "";
    szUserName = "";
    szEmail = "";
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
      if (dictionary.containsKey("name")) {
        szName = ISUtilsString.refineString(dictionary["name"]);
      }
      if (dictionary.containsKey("username")) {
        szUserName = ISUtilsString.refineString(dictionary["username"]);
      }
      if (dictionary.containsKey("email")) {
        szEmail = ISUtilsString.refineString(dictionary["email"]);
      }
    } catch (e) {
      ISUtilsGeneral.log("response: " + e.toString());
    }
  }
}
