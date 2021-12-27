import 'package:insurance/isModel/is_utils_string.dart';

class ISTutorialLinkDataModel {
  String id = "";
  String szUrl = "";
  String szTitle = "";

  ISTutorialLinkDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    szUrl = "";
    szTitle = "";
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;

    if (dictionary.containsKey("id")) {
      id = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("url")) {
      szUrl = ISUtilsString.refineString(dictionary["url"]);
    }
    if (dictionary.containsKey("title")) {
      szTitle = ISUtilsString.refineString(dictionary["title"]);
    }
  }
}
