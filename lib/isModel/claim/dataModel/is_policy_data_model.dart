import 'package:insurance/isModel/is_utils_date.dart';
import 'package:insurance/isModel/is_utils_string.dart';

class ISPolicyDataModel {

  String szPolicyNumber = "";
  String szType = "";
  DateTime? dateEffective;
  DateTime? dateExpiration;

  ISPolicyDataModel() {
    initialize();
  }

  initialize() {
    szPolicyNumber = "";
    szType = "";
    dateEffective = null;
    dateExpiration = null;
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();

    if (dictionary == null) return;

    if (dictionary.containsKey("policyNumber")) {
      szPolicyNumber = ISUtilsString.refineString(dictionary["policyNumber"]);
    }
    if (dictionary.containsKey("type")) {
      szType = ISUtilsString.refineString(dictionary["type"]);
    }
    if (dictionary.containsKey("effectiveDate")) {
      dateEffective = ISUtilsDate.getDateTimeFromStringWithFormat(
          dictionary["effectiveDate"],
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }
    if (dictionary.containsKey("expirationDate")) {
      dateEffective = ISUtilsDate.getDateTimeFromStringWithFormat(
          dictionary["expirationDate"],
          ISEnumDateTimeFormat.yyyyMMdd_HHmmss_UTC.value,
          true);
    }
  }
}
