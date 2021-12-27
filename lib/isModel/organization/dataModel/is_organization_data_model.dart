import 'package:insurance/isModel/is_utils_string.dart';
import 'package:insurance/isModel/organization/dataModel/is_organization_user_data_model.dart';
import 'package:insurance/isModel/organization/dataModel/is_partner_data_model.dart';
import 'package:insurance/isModel/organization/dataModel/is_tutorial_link_data_model.dart';

class ISOrganizationDataModel {
  String id = "";
  String parentId = "";
  String szName = "";
  String szEmail = "";
  String szType = "";
  String szPhone = "";
  String szHeroUri = "";
  String szPhoto = "";
  List<ISPartnerDataModel> arrayPartners = [];
  List<ISTutorialLinkDataModel> arrayLinks = [];
  List<ISOrganizationUserDataModel> arrayUsers = [];
  ISEnumOrganizationuserStatus enumStatus = ISEnumOrganizationuserStatus.active;
  // Offline Mode
  Map<String, dynamic> payload = {};

  ISOrganizationDataModel() {
    initialize();
  }

  initialize() {
    id = "";
    parentId = "";
    szName = "";
    szEmail = "";
    szType = "";
    szPhone = "";
    szHeroUri = "";
    szPhoto = "";
    arrayPartners = [];
    arrayLinks = [];
    arrayUsers = [];
    enumStatus = ISEnumOrganizationuserStatus.active;
    payload = {};
  }

  deserialize(Map<String, dynamic>? dictionary) {
    initialize();
    if (dictionary == null) return;

    if (dictionary.containsKey("id")) {
      id = ISUtilsString.refineString(dictionary["id"]);
    }
    if (dictionary.containsKey("parentId")) {
      parentId = ISUtilsString.refineString(dictionary["parentId"]);
    }
    if (dictionary.containsKey("name")) {
      szName = ISUtilsString.refineString(dictionary["name"]);
    }
    if (dictionary.containsKey("email")) {
      szEmail = ISUtilsString.refineString(dictionary["email"]);
    }
    if (dictionary.containsKey("phone")) {
      szPhone = ISUtilsString.refineString(dictionary["phone"]);
    }
    if (dictionary.containsKey("heroUri")) {
      szHeroUri = ISUtilsString.refineString(dictionary["heroUri"]);
    }
    if (dictionary.containsKey("partners") && dictionary["partners"] != null) {
      List<dynamic> partners = dictionary["partners"];
      for (int i = 0; i < partners.length; i++) {
        Map<String, dynamic> dict = partners[i];
        ISPartnerDataModel partner = ISPartnerDataModel();
        partner.deserialize(dict);
        if (partner.isValid()) {
          arrayPartners.add(partner);
        }
      }
    }

    if (dictionary.containsKey("users") && dictionary["users"] != null) {
      List<dynamic> users = dictionary["users"];
      for (int i = 0; i < users.length; i++) {
        Map<String, dynamic> dict = users[i];
        ISOrganizationUserDataModel user = ISOrganizationUserDataModel();
        user.deserialize(dict);
        if (user.isValid()) {
          arrayUsers.add(user);
        }
      }
    }
    if (dictionary.containsKey("links") && dictionary["links"] != null) {
      List<dynamic> links = dictionary["links"];
      for (int i = 0; i < links.length; i++) {
        Map<String, dynamic> dict = links[i];
        ISTutorialLinkDataModel link = ISTutorialLinkDataModel();
        link.deserialize(dict);
        arrayLinks.add(link);
      }
    }
    if (dictionary.containsKey("status")) {
      enumStatus = ISEnumOrganizationuserStatusExtension.fromString(
          ISUtilsString.refineString(dictionary["status"]));
    }
    payload = dictionary;
  }

  bool isValid() {
    return id.isNotEmpty;
  }

  Map<String, dynamic> serializeForOffline() {
    return payload;
  }
}
