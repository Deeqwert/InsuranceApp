import 'package:insurance/isModel/is_utils_string.dart';

class ISHoverLinkDataModel {

  String jobId = "";
  bool isEnabled = false;
  String szAndroidLink = "";
  String szIosLink = "";
  String szWebLink = "";

  ISHoverLinkDataModel() {
    initialize();
  }

  initialize() {
    jobId = "";
    isEnabled = false;
    szAndroidLink = "";
    szIosLink = "";
    szWebLink = "";
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("jobId")) {
      jobId = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("enabled")) {
      isEnabled = ISUtilsString.refineBool(dictionary["enabled"], false);
    }
    if (dictionary.containsKey("androidLink")) {
      szAndroidLink = ISUtilsString.refineString(dictionary["androidLink"]);
    }
    if (dictionary.containsKey("iOSLink")) {
      szIosLink = ISUtilsString.refineString(dictionary["iOSLink"]);
    }
    if (dictionary.containsKey("webLink")) {
      szWebLink = ISUtilsString.refineString(dictionary["webLink"]);
    }
  }

  bool isLinkAvailable() {
    return (isEnabled && szAndroidLink.isNotEmpty);
  }
}
